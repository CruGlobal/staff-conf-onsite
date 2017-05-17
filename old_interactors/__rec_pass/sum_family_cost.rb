class RecPass::SumFamilyCost
  include Interactor

  before do
    context.subtotal = Money.empty
    context.total = Money.empty
    context.total_adjustments = Money.empty
  end

  def call
    context.family.people.each do |person|
      result = RecPass::ChargePersonCost.call(person: person)

      if result.success?
        add_to_context(result)
      else
        context.fail!(error: result.error)
      end
    end
  end

  def add_to_context(result)
    context.total_adjustments += result.total_adjustments
    context.subtotal += result.subtotal
    context.total += result.total
  end
end
