class ChangeChildcareMedicalHistoryColumnsToArray < ActiveRecord::Migration
  COLUMNS = [:chronic_health, :immunizations, :health_misc, :vip_comm, :vip_stress].freeze

  def up
    COLUMNS.each do |column|
      remove_column :childcare_medical_histories, column
      add_column :childcare_medical_histories, column, :string, array: true, default: []
    end
  end

  def down
    COLUMNS.each do |column|
      change_column :childcare_medical_histories, column, :string, array: false
    end
  end
end
