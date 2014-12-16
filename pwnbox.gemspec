# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pwnbox/version'

Gem::Specification.new do |spec|
  spec.name          = 'pwnbox'
  spec.version       = Pwnbox::Version::STRING
  spec.authors       = ['Insu Yun']
  spec.email         = ['wuninsu@gmail.com']
  spec.summary       = 'Capture-The-Flag(CTF) toolkit'
  spec.description   = 'Capture-The-Flag(CTF) toolkit'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rubocop', '~> 0.28.0'
end
