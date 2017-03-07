# This application statically references certain {UserVariable} records, so we
# must ensure that they exist every time the application starts. Existing
# records will not be modified.
require_relative '../../db/user_variables.rb'

# If we're running db:setup, the table won't exist yet
if ActiveRecord::Base.connection.table_exists?('user_variables')
  SeedUserVariables.new.call unless Rails.env.test?
end
