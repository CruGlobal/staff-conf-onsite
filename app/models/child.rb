class Child < Person
  belongs_to :family
  belongs_to :childcare

  accepts_nested_attributes_for :meal_exemptions, allow_destroy: true
end
