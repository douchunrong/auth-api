# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

begin
  require 'rspec/core/rake_task'

  # TODO: rake -T should display spec task
  Rake::Task['spec'].clear

  namespace :spec do
    RSpec::Core::RakeTask.new(:smoke) do |t|
      t.rspec_opts = '--tag smoke --format documentation'
      t.exclude_pattern = './spec/e2e/**/*_spec.rb'
    end

    RSpec::Core::RakeTask.new(:no_smoke) do |t|
      t.rspec_opts = '--tag ~smoke --format documentation'
      t.exclude_pattern = './spec/e2e/**/*_spec.rb'
    end

    RSpec::Core::RakeTask.new(:e2e) do |t|
      t.rspec_opts = '--format documentation'
      t.pattern = './spec/e2e/**/*_spec.rb'
    end
  end

  task :spec => ['spec:prepare', 'spec:smoke', 'spec:no_smoke']
rescue LoadError
end
