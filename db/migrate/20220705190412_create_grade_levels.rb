class CreateGradeLevels < ActiveRecord::Migration
  def change
    create_table :grade_levels do |t|
      t.string :age
      t.string :description
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
