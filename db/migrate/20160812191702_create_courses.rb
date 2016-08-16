class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.date :start
      t.date :end

      t.timestamps
    end
  end
end
