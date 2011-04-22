require 'base64'

Gem::Specification.new do |s|
  s.name        = 'minit'
  s.version     = '0.0.1'
  s.author      = 'Phil Thompson'
  s.email       = Base64.decode64("cGhpbEBlbGVjdHJpY3Zpc2lvbnMuY29t\n")
  s.homepage    = 'http://github.com/PhilT/minit'
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Minify CSS and JS without requiring Java nor specifying individual files'
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'minit'

  s.add_dependency 'jsmin'
  s.add_dependency 'cssmin'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_path  = 'lib'
end

