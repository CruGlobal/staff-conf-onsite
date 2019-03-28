# These tasks are deleted and then redefined below
%w[default test:units test:integration].each do |t|
  Rake.application.instance_variable_get('@tasks').delete(t)
end

desc 'Run the entire suit of tests and linters'
task :default do
  border = '=' * 80
  tasks = %w[rubocop reek coffeelint bundle:audit test]

  puts "The following Rake tasks will be run: #{tasks.to_sentence}"
  tasks.each do |task|
    puts "\n#{border}\nRunning `rake #{task}`\n#{border}"
    Rake::Task[task].invoke
  end
  puts 'Success.'
end

Rake::TestTask.new('test:units') do |t|
  t.test_files = FileList['test/**/*_test.rb'].exclude(
    'test/integration/**/*_test.rb'
  )
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
