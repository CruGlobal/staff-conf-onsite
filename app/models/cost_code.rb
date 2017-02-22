class CostCode < ActiveRecord::Base
  include CostCodeHelper

  has_many :charges, class_name: 'CostCodeCharge', foreign_key: 'cost_code_id',
                     dependent: :destroy
  has_many :housing_facilities

  accepts_nested_attributes_for :charges, allow_destroy: true

  validates_associated :charges

  def to_s
    cost_code_label(self)
  end
end
