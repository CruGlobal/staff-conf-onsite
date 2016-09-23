class CreateConferenceAttendances < ActiveRecord::Migration
  def change
    create_table :conference_attendances do |t|
      t.references :conference, index: true, foreign_key: true
      t.references :attendee, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
