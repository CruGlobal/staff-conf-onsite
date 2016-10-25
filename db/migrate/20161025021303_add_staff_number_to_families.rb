class AddStaffNumberToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :staff_number, :string

    reversible do |dir|
      Family.reset_column_information

      dir.up do
        Family.transaction do
          # Grab the staff number from a family member
          Family.all.each do |family|
            if (staff_number = family.people.first.try(:staff_number))
              family.staff_number = staff_number
              family.save!
            end
          end
        end
      end
    end
  end
end
