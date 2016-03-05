# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'npm/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "npm-rails"
  spec.version       = Npm::Rails::VERSION
  spec.authors       = ["Stepan Lusnikov"]
  spec.email         = ["endenwer@gmail.com"]

  spec.summary       = "NPM & Ruby on Rails integration"
  spec.description   = "Use NPM packages in you Ruby on Rails application"
  spec.homepage      = "https://github.com/endenwer/npm-rails"
  spec.license       = "MIT"

  spec.files = Dir[
    'lib/**/*',
    'README.md',
    'LICENSE'
  ]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency 'rails', '>= 3.2'
end
