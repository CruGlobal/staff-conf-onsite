class Child < Person
  include FamilyMember

  belongs_to :family
  belongs_to :childcare

  validates :family_id, presence: true
end
