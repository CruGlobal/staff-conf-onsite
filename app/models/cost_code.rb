class CostCode < ActiveRecord::Base
  has_many :charges, class_name: 'CostCodeCharge', foreign_key: 'cost_code_id'
  has_many :housing_facilities

  accepts_nested_attributes_for :charges, allow_destroy: true

  def to_s
    CostCodeHelper.cost_code_label(self)
  end
end
