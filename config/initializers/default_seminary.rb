Attendee.where(seminary_id: nil).update_all(seminary_id: Seminary.default.id)
