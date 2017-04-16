class SetupDefaultSeminary < ActiveRecord::Migration
  def up
    Attendee.where(seminary_id: nil).update_all(seminary_id: Seminary.default.id)
  end
  def down
  end
end
