class Conference < ActiveRecord::Base
  include Moneyable

  money_attr :cents

  has_many :conference_attendances
  has_many :attendees, through: :conference_attendances
end
