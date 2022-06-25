class HotelStay < ActiveRecord::Base
  belongs_to :family
  validates :family, presence: true, uniqueness: { message: 'Family already has hotel stay' }
end
