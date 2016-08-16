class CreateCourseAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :course_attendances do |t|
      t.references :course, foreign_key: true
      t.references :person, foreign_key: true
      t.string :grade

      t.timestamps
    end
  end
end
