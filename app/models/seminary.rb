class Seminary < ActiveRecord::Base
  has_many :attendees

  monetize :course_price_cents
end
