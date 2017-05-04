class Attendee::FinancesCell < ::ShowCell
  COSTS = {
    'Conferences' => Conference::ChargeCosts,
    'Apartment Housing' => Stay::ChargeAttendeeApartment,
    'Dormitory Housing' => Stay::ChargeAttendeeDormitory,
    'Rec Pass' => RecPass::ChargePersonCost
  }.freeze

  property :attendee

  def show
    panel 'Finances', class: 'finances_panel' do
      individual_dorms_cost_list if any_housing_costs?
      cell('cost_adjustment/summary_table', self, results: cost_results).call
    end
  end

  private

  def cost_results
    @results ||= Hash[
      COSTS.map { |name, service| [name, service.call(attendee: attendee)] }
    ]
  end

  def individual_dorms_cost_list
    stays = attendee.stays
    return if stays.empty?

    table do
      tr do
        th 'Individual Stays'
        th 'Sub-total'
      end

      stays.each do |stay|
        tr do
          td { join_stay_dates(stay) }
          td { individual_dorms_cost_list_item(stay) }
        end
      end
    end
  end

  def individual_dorms_cost_list_item(stay)
    result = Stay::SingleAttendeeCost.call(stay: stay)
    if result.success?
      text_node humanized_money_with_symbol result.total
    else
      div(class: 'flash flash_error') { result.error }
    end
  end

  def any_housing_costs?
    ['Apartment Housing', 'Dormitory Housing'].any? do |name|
      cost_results[name].success?
    end
  end
end
