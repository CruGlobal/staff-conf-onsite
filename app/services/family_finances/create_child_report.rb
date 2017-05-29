module FamilyFinances
  class CreateChildReport < BaseReport
    include ChildcareHelper

    attr_accessor :child

    def cost_reports
      [stays_cost, childcare_cost, hot_lunch_cost, rec_center_cost]
    end

    def on_campus_stays
      stay_scope.select(&:on_campus?).map(&method(:create_stay_row))
    end

    def stay_adjustments
      stays_cost.total_adjustments
    end

    def childcare
      child.childcare_weeks.map(&method(:create_childcare_row)) << deposit_charge
    end

    def childcare_adjustments
      childcare_cost.total_adjustments
    end

    def hot_lunches
      child.hot_lunch_weeks.map(&method(:create_hot_lunch_row))
    end

    def hot_lunch_adjustments
      hot_lunch_cost.total_adjustments
    end

    def rec_center
      [create_row('Pass', rec_center_cost.total)]
    end

    def rec_center_adjustments
      @rec_center_adjustments ||= rec_center_cost.total_adjustments
    end

    private

    def stay_scope
      child.stays.not_in_self_provided
    end

    def create_stay_row(stay)
      cost = Stay::SingleChildDormitoryCost.call(child: child, stay: stay)
      create_row(stay.to_s, cost.total)
    end

    def stays_cost
      @stays_cost ||= Stay::ChargeChildCost.call(child: child)
    end

    def rec_center_cost
      @rec_center_cost ||= RecPass::ChargePersonCost.call(person: child)
    end

    def childcare_cost
      @childcare_cost ||=
        if child.age_group == :childcare
          Childcare::ChargeChildCost.call(child: child)
        else
          JuniorSenior::ChargeChildCost.call(child: child)
        end
    end

    def create_childcare_row(index)
      create_row(childcare_weeks_label(index),
                 childcare_cost.sum.week_charges[index])
    end

    def hot_lunch_cost
      @hot_lunch_cost ||= HotLunch::ChargeChildCost.call(child: child)
    end

    def create_hot_lunch_row(index)
      create_row(childcare_weeks_label(index),
                 hot_lunch_cost.sum.week_charges[index])
    end

    def deposit_charge
      if child.childcare_deposit?
        create_row('Deposit', childcare_cost.sum.deposit_charge)
      end
    end
  end
end
