class CreateCourseAttendances < ActiveRecord::Migration
  def change
    create_table :course_attendances do |t|
      t.references :course, foreign_key: true, index: true
      t.references :attendee, foreign_key: true, index: true
      t.string :grade

      t.timestamps

      t.index [:course_id, :attendee_id], unique: true
    end
  end
end
