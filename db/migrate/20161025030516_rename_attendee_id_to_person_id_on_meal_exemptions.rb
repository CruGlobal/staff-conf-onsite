class RenameAttendeeIdToPersonIdOnMealExemptions < ActiveRecord::Migration
  def change
    rename_column :meal_exemptions, :attendee_id, :person_id
  end
end
