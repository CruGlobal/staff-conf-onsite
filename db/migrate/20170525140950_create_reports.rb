class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.text :query
      t.string :role

      t.timestamps null: false
    end
  end
end
