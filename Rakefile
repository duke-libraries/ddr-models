begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec => ["app:db:migrate", "app:db:test:prepare"])

task :default => :spec