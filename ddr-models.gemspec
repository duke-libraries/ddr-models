# coding: utf-8
# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require 'ddr/models/version'

# Gem::Specification.new do |spec|
#   spec.name          = "ddr-models"
#   spec.version       = Ddr::Models::VERSION
#   spec.authors       = ["Jim Coble"]
#   spec.email         = ["jim.coble@duke.edu"]
#   spec.summary       = %q{Models used in the Duke Digital Repository}
#   spec.description   = %q{Models used in the Duke Digital Repository}
#   spec.homepage      = "https://github.com/duke-libraries/ddr-models"
#   spec.license       = "BSD-3-Clause"
# 
#   spec.files         = `git ls-files -z`.split("\x0")
#   spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
#   spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
#   spec.require_paths = ["lib"]
# 
#   # spec.add_dependency "active-fedora", "~> 7.1"
#   # spec.add_dependency "rails", "~> 4.1.4"
#   spec.add_dependency "hydra-head", "~> 7.2.0"
#   spec.add_dependency "hydra-validations", "~> 0.2"
#   spec.add_dependency 'clamav'
#   spec.add_dependency 'noid', '~> 0.7'
#   spec.add_development_dependency "bundler", "~> 1.6"
#   spec.add_development_dependency "rake"
# end


$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ddr/models/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ddr-models"
  s.version     = Ddr::Models::VERSION
  s.authors     = ["Jim Coble"]
  s.email       = ["jim.coble@duke.edu"]
  s.homepage    = "https://github.com/duke-libraries/ddr-models"
  s.summary     = %q{Models used in the Duke Digital Repository}
  s.description = %q{Models used in the Duke Digital Repository}
  s.license     = "BSD-3-Clause"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.6"

  s.add_dependency "hydra-head", "~> 7.2.0"
  s.add_dependency "hydra-derivatives"
  s.add_dependency "hydra-validations", "~> 0.2"
  s.add_dependency 'clamav'
  s.add_dependency 'noid', '~> 0.7'
  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails', '~> 3.0.0'
end
