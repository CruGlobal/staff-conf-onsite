class CruStudentMedicalHistory < ApplicationRecord
  include AttributePresence

  belongs_to :child
end
