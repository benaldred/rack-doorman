lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rack/doorman/version'

Gem::Specification.new do |s|
  s.name = 'rack-doorman'
  s.version = Rack::Access::VERSION

  s.authors = ["Ben Aldred"]
  s.description = "A rack middleware for limiting access to Co-op people only"
  s.email = "ben.aldred@coopdigital.co.uk"

  s.files = Dir.glob("{bin,lib}/**/*") + %w(Rakefile README.md)
  s.homepage = 'http://github.com/coopdigital/rack-doorman'
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{for limiting access to Co-op people only}
  s.test_files = Dir.glob("spec/**/*")

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'rack'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'
end
