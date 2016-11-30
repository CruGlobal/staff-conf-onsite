class CostCode < ActiveRecord::Base
  has_many :charges, class_name: 'CostCodeCharge', foreign_key: 'cost_code_id'

  accepts_nested_attributes_for :charges, allow_destroy: true
end
