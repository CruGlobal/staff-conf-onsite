guard :minitest do
  # Editing tests themselves
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_helper\.rb$})  { 'test' }
  watch(%r{^test/support/(.+)\.rb$}) { 'test' }

  # Unit tests
  watch(%r{^app/(.+)\.rb$})                               { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
  watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/#{m[1]}_test.rb" }
  watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/#{m[1]}_test.rb" }

  # Integration tests
  watch(%r{^app/admin/(.+).rb$})            { |m| Dir["test/integration/#{m[1]}/*_test.rb"] }
  watch(%r{^app/cells/([^/]+)/.+_cell.rb$}) { |m| Dir["test/integration/#{m[1]}/*_test.rb"] }
end
