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

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.require_paths = ["lib", "app/models"]

  s.add_dependency "rails", "~> 4.1.6"	
  s.add_dependency "active-fedora", "~> 7.0"
  s.add_dependency "hydra-core", "~> 7.2"
  s.add_dependency "hydra-derivatives"
  s.add_dependency "hydra-validations"
  s.add_dependency "clamav"
  s.add_dependency "noid", "~> 0.7"
  s.add_dependency "ddr-antivirus", "~> 1.2"
  s.add_dependency "devise-remote-user"
  s.add_dependency "grouper-rest-client"

  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.1"
  s.add_development_dependency "factory_girl_rails", "~> 4.4"
  s.add_development_dependency "jettywrapper"
  s.add_development_dependency "database_cleaner"
end
