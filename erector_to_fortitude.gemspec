$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'erector_to_fortitude/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'erector_to_fortitude'
  s.version = ErectorToFortitude::VERSION
  s.required_ruby_version = Gem::Requirement.new('>= 2.0.0')
  s.authors = ['Adam Becker']
  s.summary = 'Converts Erector views to Fortitude syntax.'
  s.email = 'adam@dobt.co'
  s.license = 'MIT'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {features,spec}/*`.split("\n")
  s.homepage = 'http://github.com/ajb/erector_to_fortitude'

  s.add_dependency 'parser'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
end
