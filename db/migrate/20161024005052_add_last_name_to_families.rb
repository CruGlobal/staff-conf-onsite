class AddLastNameToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :last_name, :string

    reversible do |dir|
      Family.reset_column_information

      # Grab family name from a family member
      Family.all.each do |family|
        dir.up do
          last_name = family.people.first.try(:last_name)
          if last_name.blank?
            family.last_name = '<UNKNOWN>'
          else
            family.last_name = last_name
          end
          family.save!
        end
      end
    end
  end
end
