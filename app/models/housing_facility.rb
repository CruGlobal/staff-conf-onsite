class HousingFacility < ApplicationRecord
  has_paper_trail

  has_many :rooms, dependent: :destroy

  def audit_name
    "#{super}: #{name}"
  end
end
