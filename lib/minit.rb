require 'cssmin'
require 'jsmin'

class Minit
  def package type, globs, create
    compressor = {:javascripts => JSMin, :stylesheets => CSSMin}[type]
    extension = {:javascripts => 'js', :stylesheets => 'css'}[type]
    include_method = {:javascripts => 'javascript_include_tag', :stylesheets => 'stylesheet_link_tag'}[type]
    raise "package type unknown. Only :javascripts or :stylesheets supported." unless compressor && extension && include_method
    package_name = "packaged.#{extension}"
    files = []
    includes = (compress? && !create) ? File.join('/assets', package_name) : []
    asset_path = File.join(Rails.root, 'public', type.to_s, '/')

    file = File.open(File.join(Rails.root, 'public', 'assets', package_name), 'w') if (compress? && create)
    globs.each do |glob|
      Dir.glob(File.join(asset_path, glob)).each do |path|
        next if files.include?(path)
        files << path
        if compress? && create
          file.puts compressor.minify(File.open(path))
        elsif !create
          includes << path.gsub(asset_path, '')
        end
      end
    end
    file.close if file
    send(include_method, includes)
  end

  def compress?
    !%w(development test).include?(Rails.env)
  end

  def include_stylesheets create = false
    package :stylesheets, %w(reset.css default.css lib/**/*.css **/*.css), create
  end

  def include_javascripts create = false
    package :javascripts, %w(lib/**/*.js plugins/**/*.js **/*.js), create
  end
end

minit = Minit.new
if minit.compress?
  puts 'Compressing assets...'
  minit.include_stylesheets true
  minit.include_javascripts true
  puts 'Finished compressing assets.'
end

