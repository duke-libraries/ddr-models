# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "ddr/models/version"

Gem::Specification.new do |s|
  s.name        = "ddr-models"
  s.version     = Ddr::Models::VERSION
  s.authors     = ["Jim Coble", "David Chandek-Stark"]
  s.email       = ["lib-drs@duke.edu"]
  s.homepage    = "https://github.com/duke-libraries/ddr-models"
  s.summary     = %q{Models used in the Duke Digital Repository}
  s.description = %q{Models used in the Duke Digital Repository}
  s.license     = "BSD-3-Clause"

  s.files       = `git ls-files -z`.split("\x0")
  s.test_files  = s.files.grep(%r{^spec/})

  s.require_paths = ["lib", "app/models"]

  s.add_dependency "rails", "~> 4.1.13"
  s.add_dependency "active-fedora", "~> 9.4"
  s.add_dependency "hydra-core", "~> 9.3"
  s.add_dependency "hydra-validations", "~> 0.5"
  s.add_dependency "devise", "~> 3.4"
  s.add_dependency "omniauth-shibboleth", "~> 1.2.0"
  s.add_dependency "grouper-rest-client"
  s.add_dependency "ezid-client", "~> 1.1", ">= 1.1.1"
  s.add_dependency "resque", "~> 1.25"
  s.add_dependency "rdf-vocab", "~> 0.8"
  s.add_dependency "net-ldap", "~> 0.11"
  s.add_dependency "cancancan", "~> 1.12"
  s.add_dependency "ddr-aux-client", "~> 1.2", ">= 1.2.2"
  s.add_dependency "ddr-antivirus", "2.0.0"

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.1"
  s.add_development_dependency "rspec-its"
  s.add_development_dependency "factory_girl_rails", "~> 4.4"
  s.add_development_dependency "jettywrapper", "~> 2.0"
  s.add_development_dependency "database_cleaner"
end
