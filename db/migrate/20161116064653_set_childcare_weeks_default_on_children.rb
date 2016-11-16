class SetChildcareWeeksDefaultOnChildren < ActiveRecord::Migration
  def change
    change_column_default :children, :childcare_weeks, ""
  end
end
