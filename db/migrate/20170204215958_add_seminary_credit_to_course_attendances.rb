class AddSeminaryCreditToCourseAttendances < ActiveRecord::Migration
  def change
    add_column :course_attendances, :seminary_credit, :boolean, default: false

    reversible do |dir|
      dir.up   { change_column :course_attendances, :grade, :integer }
      dir.down { change_column :course_attendances, :grade, :string }
    end
  end
end
