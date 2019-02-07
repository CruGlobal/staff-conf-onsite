class AddFoodIntoleranceToChildcareMedicalHistory < ActiveRecord::Migration
  def change
    add_column :childcare_medical_histories, :food_intolerance, :text
  end
end
