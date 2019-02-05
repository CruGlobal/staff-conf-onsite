class AddMedicalHistoryApprovalToPeople < ActiveRecord::Migration
  def change
    add_column :people, :medical_history_approval, :boolean, :default => false
  end
end
