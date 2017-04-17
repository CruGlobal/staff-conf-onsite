class Attendee::CostCell < ::ShowCell
  property :attendee

  def temporary_conference_cost_panel
    panel 'Conference Costs (Temporary panel for demo)', class: 'TODO_panel' do
      cell('cost_adjustment/summary',
           self, result: Conference::ChargeCosts.call(attendee: attendee)).call
    end
  end

  # TODO: This is for client-demo purposes. This will be part of some report in
  #       the future.
  def temporary_stay_cost_panel
    panel 'Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      result = Stay::ChargeAttendee.call(attendee: attendee)

      temporary_stay_individual_dorms_cost_list if result.success?
      cell('cost_adjustment/summary', self, result: result).call
    end
  end

  private

  def temporary_stay_individual_dorms_cost_list
    stays = attendee.stays
    return if stays.empty?

    h4 'Individual Stays:'
    dl do
      stays.each do |stay|
        dt { join_stay_dates(stay) }
        dd { temporary_stay_individual_dorms_cost_list_item(stay) }
      end
    end
  end

  def temporary_stay_individual_dorms_cost_list_item(stay)
    result = Stay::SingleAttendeeCost.call(stay: stay)
    if result.success?
      text_node humanized_money_with_symbol result.total
    else
      div(class: 'flash flash_error') { result.error }
    end
  end
end
