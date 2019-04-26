class RenameMedicalHistoryApprovalToFormsApproved < ActiveRecord::Migration
  def change
    rename_column :people, :medical_history_approval, :forms_approved
  end
end
