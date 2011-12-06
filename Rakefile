require 'bundler/gem_tasks'
require "cucumber/rake/task"

task :default => [:test]
  
Cucumber::Rake::Task.new(:test) do |task|
  task.cucumber_opts = ["features"]
end
