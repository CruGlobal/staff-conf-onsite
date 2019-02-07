class ChangePersonIdToChildIdOnChildcareMedicalHistory < ActiveRecord::Migration
  def change
    rename_column :childcare_medical_histories, :person_id, :child_id
  end
end
