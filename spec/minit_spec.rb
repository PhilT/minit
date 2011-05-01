$LOAD_PATH << 'lib'
require 'minitest/autorun'

class Rails
  @@env = 'development'
  def self.env; @@env; end
  def self.env= env; @@env = env; end
  def self.root; '/root'; end
end

class Outputs
  attr_accessor :output, :stylesheets, :javascripts
  def reset
    self.output = []
    self.stylesheets = []
    self.javascripts = []
  end
end
$outputs = Outputs.new

def puts str
  $outputs.output << str
end

def stylesheet_link_tag *args
  $outputs.stylesheets + args
end

def javascript_include_tag *args
  $outputs.javascripts + args
end

require 'minit'
require 'fakefs'
def create path, content
  FileUtils.mkdir_p File.dirname(path)
  File.open path, 'w' do |f|
    f.puts content
  end
end
FileUtils.mkdir_p '/root/public/assets'
create '/root/public/stylesheets/reset.css', 'body {padding: 0}'
create '/root/public/stylesheets/default.css', 'img {border: none}'
create '/root/public/stylesheets/application.css', 'body {margin: 20px auto}'
create '/root/public/stylesheets/lib/jquery.ui.css', '.some_ui {}'
create '/root/public/javascripts/lib/jquery.js', ''
create '/root/public/javascripts/plugins/jquery_ui/jquery.menu.js', ''
create '/root/public/javascripts/application.js', ''

describe 'Minit' do
  before(:each) do
    $outputs.reset
    @subject = Minit.new
  end

  describe 'initialization' do
    it 'calls include methods with create options when compressing' do
      Rails.env = 'production'
      load 'minit.rb'
      $outputs.output.must_equal ['Compressing assets...', 'Finished compressing assets.']
      $outputs.stylesheets.must_equal []
      $outputs.javascripts.must_equal []
    end

    it 'does not do anything when no compression required' do
      Rails.env = 'development'
      load 'minit.rb'
      $outputs.output.must_equal []
      $outputs.stylesheets.must_equal []
      $outputs.javascripts.must_equal []
    end
  end

  describe 'compress?' do
    it 'returns false for development environment' do
      Rails.env = 'development'
      @subject.compress?.must_equal false
    end

    it 'returns false for test environment' do
      Rails.env = 'test'
      @subject.compress?.must_equal false
    end

    it 'returns true for production environment' do
      Rails.env = 'production'
      @subject.compress?.must_equal true
    end

    it 'returns true for any other environment' do
      Rails.env = 'other'
      @subject.compress?.must_equal true
    end
  end

  describe 'package' do
    it 'raises when type is not javascripts or stylesheets' do
      lambda { @subject.package :something, nil, nil }.must_raise RuntimeError
    end
  end

end

