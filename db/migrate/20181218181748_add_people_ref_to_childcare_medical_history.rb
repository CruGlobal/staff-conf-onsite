class AddPeopleRefToChildcareMedicalHistory < ActiveRecord::Migration
  def change
    add_reference :childcare_medical_histories, :person, index: true, foreign_key: true
  end
end
