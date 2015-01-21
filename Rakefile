begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

APP_ROOT = File.dirname(__FILE__)

JETTY_CONFIG = { 
	jetty_home: File.join(APP_ROOT, "jetty"),
	jetty_port: 8983,
	startup_wait: 60,
	quiet: true,
	java_opts: ["-Xmx256m", "-XX:MaxPermSize=128m"]
}

require 'rspec/core/rake_task'
require 'jettywrapper'

Jettywrapper.instance.base_path = APP_ROOT

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec => ["app:db:migrate", "app:db:test:prepare"])

desc "Run the CI build"
task :ci => ["jetty:clean"] do
  Jettywrapper.wrap(JETTY_CONFIG) do
    Rake::Task['spec'].invoke
  end
end

task :default => :spec
