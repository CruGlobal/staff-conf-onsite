module Moneyable
  extend ActiveSupport::Concern

  included do
    # TODO: use with CostAdjustment after this branch is merged with the
    #       cost-adjustments branch
    def self.money_attr(*attrs)
      attrs.each do |attr|
        define_method("#{attr}=") do |cents|
          if cents.is_a?(String)
            super(cents.gsub(/\D/, '').to_i)
          else
            super(cents)
          end
        end
      end
    end
  end
end
