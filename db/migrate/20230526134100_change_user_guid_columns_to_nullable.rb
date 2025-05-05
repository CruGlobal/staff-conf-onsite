class ChangeUserGuidColumnsToNullable < ActiveRecord::Migration[6.1]
  def up
    change_column_null :users, :guid, true
  end

  def down  
    change_column_null :users, :guid, false 
  end
end
