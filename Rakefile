# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Custom default Rake task to handle code analysis and testing
if Rails.env.test?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  require 'reek/rake/task'
  Reek::Rake::Task.new

  require 'bundler/audit/task'
  Bundler::Audit::Task.new

  task :default do
    tasks = ['bundle:audit', 'rubocop', 'reek']
    puts "\n\nRunning code analysis..."
    puts "The following Rake tasks will be run: #{tasks.to_sentence}"
    puts 'To run only tests (without code analysis) use `rake test`'
    tasks.each do |task|
      puts "\n\nRunning `rake #{task}`:"
      Rake::Task[task].invoke
    end
  end
end
