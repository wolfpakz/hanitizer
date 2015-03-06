# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hanitizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'hanitizer'
  spec.version       = Hanitizer::VERSION
  spec.authors       = ['Dan Porter']
  spec.email         = ['wolfpak.z@gmail.com']
  spec.summary       = %q{Data sanitizer for SQL databases}
  spec.description   = %q{Reduce the risks of having production data in the hands of developers.}
  spec.homepage      = 'https://github.com/wolfpakz/hanitizer'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faker', '> 0'
  spec.add_dependency 'inflector', '> 0'
  spec.add_dependency 'mysql2', '> 0'
  spec.add_dependency 'pg', '> 0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0.0'
end
