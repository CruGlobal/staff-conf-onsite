require_relative '../user_variables.rb'

class RunUserVariableSeeds < ActiveRecord::Migration
  def change
    # It seems that the CONFID UserVariable was previously created by a user,
    # but now that the code is referencing it we have added it into the seeds.
    UserVariable.find_by(code: 'CONFID').update!(short_name: 'conference_id')

    SeedUserVariables.new.call unless Rails.env.test?
  end
end
