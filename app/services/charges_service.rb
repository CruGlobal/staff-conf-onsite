class ChargesService < ApplicationService
  attr_accessor :charges, :cost_adjustments, :total_adjustments, :subtotal,
                :total

  after_initialize :default_values

  def assign_totals(other)
    self.total_adjustments = other.total_adjustments
    self.subtotal = other.subtotal
    self.total = other.total
  end

  private

  def default_values
    self.charges ||= Hash.new { |h, v| h[v] = Money.empty }

    self.total_adjustments ||= Money.empty
    self.subtotal ||= Money.empty
    self.total ||= Money.empty
  end
end
