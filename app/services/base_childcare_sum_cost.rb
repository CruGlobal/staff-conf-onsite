class BaseChildcareSumCost < ChargesService
  attr_accessor :child

  IS_MULTI_WEEK_CONF = false
  # System was built for a conference over 4 weeks, so charges were done per week.  
  # Now there is only a single week, but may go back, so left code and a flag {#IS_MULTI_WEEK_CONF}
  # Currently using the 5th entry in hot lunch weeks (0 index so 4) 
  WEEK_INDEX = 4

  def call
    charges[age_group] += week_charges.values.inject(Money.empty, :+)
    charges[age_group] += deposit_charge

    self.cost_adjustments = child.cost_adjustments
  end

  def tuition_charges
    return Money.empty if child.childcare_weeks.empty?

    if child.childcare_care_grade?
      UserVariable["CARESC"]
    elsif child.childcare_camp_grade?
      UserVariable["CAMPSC"]    
    elsif child.crustu_grade?
      UserVariable["junior_senior_week_4"]
    else
      Money.empty
    end
  end


  # @return Hash[Integer, Money] a map of week numbers to the child's fee for
  #   that week
  def week_charges
    if (IS_MULTI_WEEK_CONF)      
      @week_charges ||=
        Hash[child.childcare_weeks.map { |index| [index, charge(index)] }]
    else
      @week_charges ||= Hash[WEEK_INDEX, tuition_charges]      
    end
  end

  def deposit_charge
    if child.childcare_deposit?
      UserVariable[:childcare_deposit]
    else
      Money.empty
    end
  end

  protected

  # The only difference in calculating this cost between "children" and
  # "juniors and seniors" is the +UserVariable+ used for the weekly rate.
  def age_group
    raise NotImplementedError
  end

  private

  def charge(index)
    UserVariable[age_group_symbol("week_#{index}")]
  end

  def age_group_symbol(suffix)
    format('%s_%s', age_group, suffix).to_sym
  end
end
