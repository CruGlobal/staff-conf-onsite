class Conference < ActiveRecord::Base
  monetize :price_cents

  has_many :conference_attendances
  has_many :attendees, through: :conference_attendances
end
