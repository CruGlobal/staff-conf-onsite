class AddParentIdToMinistries < ActiveRecord::Migration
  def change
    add_reference :ministries, :parent, index: true, foreign_key: true
  end
end
