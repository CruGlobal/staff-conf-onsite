module ViewsHelper
  def country_select
    ::CountryHelper.country_select
  end

  def country_name(code)
    ::CountryHelper.country_name(code)
  end

  def gender_select
    ::PersonHelper.gender_select
  end

  def gender_name(g)
    ::PersonHelper.gender_name(g)
  end

  def format_phone(number)
    ::TextHelper.format_phone(number)
  end

  def html_summary(html)
    ::TextHelper.html_summary(html)
  end

  def meal_type_select
    ::MealHelper.meal_type_select
  end

  def age(birthdate)
    ::PersonHelper.age(birthdate)
  end

  def family_name(family)
    ::PersonHelper.family_name(family)
  end
end
