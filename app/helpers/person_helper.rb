module PersonHelper
  module_function

  def gender_select
    Person::GENDERS.map { |k, v| [v, k] }
  end

  def gender_name(g)
    Person::GENDERS[g.to_sym]
  end

  def age(dob)
    now = Time.now.utc.to_date

    now.year - dob.year - (after_birthday(dob, now) ? 0 : 1)
  end

  def after_birthday(dob, now)
    now.month > dob.month || (now.month == dob.month && now.day >= dob.day)
  end

  def family_name(family)
    if (last_name = family.people.first.try(:last_name))
      "#{last_name} Family"
    else
      "Family ##{family.id}"
    end
  end
end
