class CreateChildcareMedicalHistories < ActiveRecord::Migration
  def change
    create_table :childcare_medical_histories do |t|
      t.text :allergy

      t.timestamps null: false
    end
  end
end
