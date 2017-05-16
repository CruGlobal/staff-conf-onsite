class Child::FinancesCell < ::ShowCell
  property :child

  def show
    panel 'Finances', class: 'finances_panel' do
      individual_dorms_cost_list if child.stays.any?
      cell('cost_adjustment/summary_table', self, results: cost_results).call
    end
  end

  private

  def cost_results
    @results ||=
      if child.age_group == :childcare
        childcare_cost_results
      else
        junior_senior_cost_results
      end
  end

  def childcare_cost_results
    @childcare_results ||= {
      'Housing' => Stay::ChargeChildCost.call(child: child),
      'Rec Pass' => RecPass::ChargePersonCost.call(person: child),
      'Childcare' => Childcare::ChargeCosts.call(child: child),
      'Hot Lunches' => HotLunch::ChargeChildCost.call(child: child)
    }
  end

  def junior_senior_cost_results
    @junior_results ||= {
      'Housing' => Stay::ChargeChildCost.call(child: child),
      'Rec Pass' => RecPass::ChargePersonCost.call(child: child),
      'Junior/Senior' => JuniorSenior::ChargeChildCost.call(child: child),
      'Hot Lunches' => HotLunch::ChargeChildCost.call(child: child)
    }
  end

  def individual_dorms_cost_list
    stays = child.stays
    return if stays.empty?

    table do
      tr do
        th 'Dormatory Stays'
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
    result = Stay::SingleChildDormitoryCost.call(child: child, stay: stay)
    text_node humanized_money_with_symbol result.total
  rescue => e
    div(class: 'flash flash_error') { e.message }
  end
end
