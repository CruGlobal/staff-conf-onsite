class ChildcareMedicalHistory < ApplicationRecord
  include AttributePresence

  belongs_to :child
end
