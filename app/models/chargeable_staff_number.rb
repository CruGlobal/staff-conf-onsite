class ChargeableStaffNumber < ApplicationRecord
  belongs_to :family, primary_key: :staff_number, foreign_key: :staff_number, optional: true
end
