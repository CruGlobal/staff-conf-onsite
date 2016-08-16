class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.date :date
      t.references :person, foreign_key: true
      t.string :meal_type

      t.timestamps
    end
  end
end
