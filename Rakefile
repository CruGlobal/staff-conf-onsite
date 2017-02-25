# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Custom default Rake task to handle code analysis and testing
require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'reek/rake/task'
Reek::Rake::Task.new

require 'bundler/audit/task'
Bundler::Audit::Task.new

# These tasks are redefined below
%w(test test:integration).each do |t|
  Rake.application.instance_variable_get('@tasks').delete(t)
end

task :default do
  tasks = %w(bundle:audit rubocop reek test)

  puts "\n\nRunning code analysis..."
  puts "The following Rake tasks will be run: #{tasks.to_sentence}"
  puts 'To run only tests (without code analysis) use `rake test`'
  tasks.each do |task|
    puts "\n\nRunning `rake #{task}`:"
    Rake::Task[task].invoke
  end
end

Rake::TestTask.new('test:unit') do |t|
  t.pattern = 'test/{controllers,lib,models}/*_test.rb'
  t.description = 'Run quicker unit tests'
  t.libs << 'test'
  t.warning = false
  t.verbose = true
end

Rake::TestTask.new('test:integration') do |t|
  t.pattern = 'test/integration/*_test.rb'
  t.description = 'Run slower integration tests'
  t.libs << 'test'
  t.warning = false
  t.verbose = true
end

desc 'Run unit tests and then integration tests'
task test: %i(test:unit test:integration)

# Documentation
YARD::Rake::YardocTask.new do |t|
  t.files = ['./app/**/*.rb']
end
