class Childcare < ApplicationRecord
  belongs_to :family
  has_many :children

  CHILDCARE_WEEKS = ['No Childcare Needed','Week 1','Week 2', 'Week 3',
                     'Week 4', 'US STAFF CONFERENCE']
end
