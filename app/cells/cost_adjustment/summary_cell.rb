class CostAdjustment::SummaryCell < ::ShowCell
  def show
    if result.success?
      adjustments_table
    else
      div(class: 'flash flash_error') { result.error }
    end
  end

  private

  def result
    @result ||= @options.fetch(:result)
  end

  def adjustments_table
    r = result

    table do
      adjustments_table_head

      tr do
        td { humanized_money_with_symbol r.subtotal }
        td { humanized_money_with_symbol r.total_adjustments * -1 }
        td { humanized_money_with_symbol r.total }
      end
    end
  end

  def adjustments_table_head
    tr do
      th { 'Sub-Total' }
      th { 'Adjustments' }
      th { 'Total' }
    end
  end
end
