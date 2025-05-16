class ChangeRestrictionFieldsDatatype < ActiveRecord::Migration[7.1]
  def up
    remove_column :cru_student_medical_histories, :cs_restriction_certified
    add_column :cru_student_medical_histories, :cs_restriction_certified, :string    

    remove_column :childcare_medical_histories, :cc_restriction_certified
    add_column :childcare_medical_histories, :cc_restriction_certified, :string

    add_column :people, :childcare_cancellation_fee, :boolean, default: false, null: false
    add_column :people, :childcare_late_fee, :boolean, default: false, null: false
    add_column :people, :county, :string
  end

  def down
    remove_column :cru_student_medical_histories, :cs_restriction_certified
    add_column :cru_student_medical_histories, :cs_restriction_certified, :string, array: true, default: [], null: true    

    remove_column :childcare_medical_histories, :cc_restriction_certified
    add_column :childcare_medical_histories, :cc_restriction_certified, :string, array: true, default: [], null: true

    remove_column :people, :childcare_cancellation_fee
    remove_column :people, :childcare_late_fee
    remove_column :people, :county
  end
end
