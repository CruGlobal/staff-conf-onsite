module PersonHelper
  # @return [Family,nil] The family specified by the `family_id` query param
  def param_family
    @param_family ||=
      if (id = params[:family_id])
        Family.find(id)
      end
  end

  module_function

  def gender_select
    Person::GENDERS.map { |k, v| [v, k] }
  end

  def gender_name(g)
    Person::GENDERS[g.to_sym]
  end

  # @param dob [Date]
  # @return [FixNum, nil] the age, in years, of a person born on the given date,
  #   or nil if the given date is nil
  def age(dob)
    return nil if dob.nil?

    now = Time.now.utc.to_date

    now.year - dob.year - (after_birthday(dob, now) ? 0 : 1)
  end

  def after_birthday(dob, now)
    now.month > dob.month || (now.month == dob.month && now.day >= dob.day)
  end

  def family_label(family)
    "#{family.last_name} Family ##{family.id}"
  end

  def last_name_label(person)
    if person.last_name == person.family.last_name
      "#{person.last_name} ##{person.family_id}"
    else
      "#{person.last_name} (#{family_label(person.family)})"
    end
  end
end
