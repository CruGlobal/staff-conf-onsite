class AddCodeToMinistries < ActiveRecord::Migration
  def change
    add_column :ministries, :code, :string, default: Ministry::CODES[0]
    change_column_null :ministries, :code, false
  end
end
