class Attendee::FinancesCell < ::ShowCell
  property :attendee

  def show
    panel 'Finances', class: 'finances_panel' do
      individual_dorms_cost_list
      cell('cost_adjustment/summary_table', self, results: cost_results).call
    end
  end

  private

  def cost_results
    @results ||= {
      'Conferences' => Conference::ChargePersonCost.call(person: attendee),
      'Rec Pass' => RecPass::ChargePersonCost.call(person: attendee),

      'Apartment Housing' =>
        Stay::ChargeAttendeeApartment.call(attendee: attendee),
      'Dormitory Housing' =>
        Stay::ChargeAttendeeDormitory.call(attendee: attendee)
    }.freeze
  end

  def stay_cost_results
    @stay_results ||= Hash[
      STAY_COSTS.map do |name, service|
        [name, service.call(attendee: attendee)]
      end
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
    text_node humanized_money_with_symbol result.total
  rescue => e
    div(class: 'flash flash_error') { e.message }
  end
end
