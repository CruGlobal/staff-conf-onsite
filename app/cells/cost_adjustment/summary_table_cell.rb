class CostAdjustment::SummaryTableCell < ::ShowCell
  def show
    adjustments_table
  end

  private

  def results
    @results ||= @options.fetch(:results)
  end

  def adjustments_table
    table class: 'adjustments-table' do
      adjustments_table_head

      results.each do |category, result|
        tr do
          td(class: 'adjustments-table__category') { category }
          adjustment_cells(result)
        end
      end

      grand_total_row
    end
  end

  def adjustments_table_head
    tr do
      th { 'Category' }
      th { 'Sub-Total' }
      th { 'Adjustments' }
      th { 'Total' }
    end
  end

  def adjustment_cells(r)
    td { humanized_money_with_symbol r.subtotal }
    td { humanized_money_with_symbol r.total_adjustments * -1 }
    td { humanized_money_with_symbol r.total }
  end

  def adjustment_error(r)
    td(colspan: 3) { r.message }
  end

  def grand_total_row
    tr class: 'adjustments-table__grand-total' do
      td(class: 'adjustments-table__category') { 'Grand Total' }
      td { humanized_money_with_symbol sum_attribute(:subtotal) }
      td { humanized_money_with_symbol sum_attribute(:total_adjustments) * -1 }
      td { humanized_money_with_symbol sum_attribute(:total) }
    end
  end

  def sum_attribute(attribute)
    results.values.map(&attribute).inject(Money.empty, :+)
  end
end
