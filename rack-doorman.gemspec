# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rack/doorman/version'

Gem::Specification.new do |s|
  s.name = 'rack-doorman'
  s.version = Rack::Access::VERSION
  s.authors = ["Ben Aldred"]
  s.description = "A rack middleware for limiting access to Co-op people only"
  s.email = "ben.aldred@coopdigital.co.uk"

  s.homepage = 'http://github.com/coopdigital/rack-doorman'
  s.summary = %q{for limiting access to Co-op people only}

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]

  s.test_files = Dir.glob("spec/**/*")

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency "rack", "~>2.0.3"

  s.add_development_dependency "rack-test", "~> 0.6.3"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
end
