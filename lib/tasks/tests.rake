# These tasks are deleted and then redefined below
%w[default test:units test:integration].each do |t|
  Rake.application.instance_variable_get('@tasks').delete(t)
end

border = '=' * 80
code_analysis_tasks = %w[rubocop reek coffeelint bundle:audit]

desc 'Run all tests and code analysis'
task :default do
  all_tasks = code_analysis_tasks + %w[test]
  puts "The following Rake tasks will be run: #{all_tasks.to_sentence}"
  all_tasks.each do |task|
    puts "\n#{border}\nRunning `rake #{task}`\n#{border}"
    Rake::Task[task].invoke
  end
  puts 'Success.'
end

desc 'Run code analysis'
task :analysis do
  puts "The following Rake tasks will be run: #{code_analysis_tasks.to_sentence}"
  code_analysis_tasks.each do |task|
    puts "\n#{border}\nRunning `rake #{task}`\n#{border}"
    Rake::Task[task].invoke
  end
  puts 'Success.'
end

Rake::TestTask.new('test:units') do |t|
  t.test_files = FileList['test/**/*_test.rb'].exclude(
    'test/integration/**/*_test.rb'
  )
  t.description = 'Run quicker unit tests (all tests except integration tests)'
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
