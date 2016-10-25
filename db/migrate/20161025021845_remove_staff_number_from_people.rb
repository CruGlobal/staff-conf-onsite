class RemoveStaffNumberFromPeople < ActiveRecord::Migration
  def change
    reversible do |dir|
      Person.reset_column_information

      dir.down do
        Person.transaction do
          # Grab the staff number from the family
          Person.all.each do |person|
            if (staff_number = person.family.try(:staff_number))
              person.staff_number = staff_number
              person.save!
            end
          end
        end
      end
    end

    remove_column :people, :staff_number, :string
  end
end
