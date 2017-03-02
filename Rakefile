# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Custom default Rake task to handle code analysis and testing
require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'reek/rake/task'
Reek::Rake::Task.new

require 'bundler/audit/cli'
namespace :bundle do
  desc 'Updates the ruby-advisory-db then runs bundle-audit'
  task :audit do
    ignored =
      File.open("#{Rails.root}/.bundle-audit-ignored").
        each_line.
        map { |line| line.sub(/#.+/, '').strip }.
        select(&:present?).
        map { |ignore| ['-i', ignore] }

    Bundler::Audit::CLI.start(['update'])
    Bundler::Audit::CLI.start((['check'] + ignored).flatten)
  end
end

# These tasks are redefined below
%w(default test test:integration).each do |t|
  Rake.application.instance_variable_get('@tasks').delete(t)
end

desc 'Run the entire suit of tests and linters'
task :default do
  border = '=' * 80
  tasks = %w(test:unit test:integration rubocop reek bundle:audit)

  puts "The following Rake tasks will be run: #{tasks.to_sentence}"
  tasks.each do |task|
    puts "\n#{border}\nRunning `rake #{task}`\n#{border}"
    Rake::Task[task].invoke
  end
  puts 'Success.'
end

Rake::TestTask.new('test:unit') do |t|
  t.pattern = 'test/{controllers,lib,models}/**/*_test.rb'
  t.description = 'Run quicker unit tests'
  t.libs << 'test'
  t.warning = false
  t.verbose = true
end

Rake::TestTask.new('test:integration') do |t|
  t.pattern = 'test/integration/**/*_test.rb'
  t.description = 'Run slower integration tests'
  t.libs << 'test'
  t.warning = false
  t.verbose = true
end

desc 'Run unit tests and then integration tests'
task test: %i(test:unit test:integration)

# Documentation
if Rails.env.development?
  YARD::Rake::YardocTask.new do |t|
    t.files = ['./app/**/*.rb']
  end
end
