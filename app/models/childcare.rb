class Childcare < ApplicationRecord
  has_paper_trail

  belongs_to :family
  has_many :children

  # The list of individual weeks that children may attend.
  #
  # @note {Child#childcare_weeks=} accepts a list of indexes into this list,
  #   not the strings themselves.
  CHILDCARE_WEEKS = ['Week 1', 'Week 2', 'Week 3', 'Week 4',
                     'US STAFF CONFERENCE'].freeze

  def audit_name
    "#{super}: #{name}"
  end
end
