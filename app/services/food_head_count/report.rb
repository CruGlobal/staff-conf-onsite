# The resulting table of Daily Food Head Counts. Each element is a sub-table of
# {FoodHeadCount::CafeteriaDate} for that date. Each +CafeteriaDate+ contains
# the various meal counts for a single date/cafeteria pair.
#
# @example
#   2017-01-02:
#     'McDonalds':
#       adult_breakfast: 15
#       adult_lunch:      0
#       adult_dinner:     8
#     'Burger King':
#       teen_breakfast:   0
#       teen_dinner:      2
#       child_breakfast: 11
class FoodHeadCount::Report < ApplicationService
  CORBETT_CONFERENCES = [
      'Missional Team Leader Training Coach or Design Team Member',
      'Missional Team Leader Training Participant',
      'Missional Team Leader Spouse',
      'XTrack Training Team',
      'XTrack Participant',
      'Colorado Operations Summer Mission'
  ]

  CORBETT_DORMS = [
      'Corbett (suite style, no A/C)',
      'Parmelee'
  ]

  RAMS_HORN_DORMS = [
      'Summit (suite style, with A/C)',
      'Academic Village -E (private bathroom, with A/C)',
      'Academic Village -H (private bathroom, with A/C)'
  ]

  # An optional start date. If missing, today's date is used
  attr_accessor :start_at

  # An optional end date. If missing, the {Stay#departed_at} of the most-recent
  # dorm stay will be used
  attr_accessor :end_at

  def call
    # date_range.each do |date|
    #   head_counts.add(FoodHeadCount::Row.new(date, Person))
    #   head_counts.add(FoodHeadCount::Row.new(date, Person.corbett))
    #   head_counts.add(FoodHeadCount::Row.new(date, Person.durrell))
    #   head_counts.add(FoodHeadCount::Row.new(date, Person.rams_horn))
    # end

    @all = {}
    @corbett = {}
    @durrell = {}
    @rams_horm = {}
    date_range.each do |date|
      @all = {date: date, cafeteria: 'Total', adult_breakfast: 0, adult_lunch: 0, adult_dinner: 0, child_breakfast: 0, child_lunch: 0, child_dinner: 0}
      @corbett = {date: date, cafeteria: 'Corbett', adult_breakfast: 0, adult_lunch: 0, adult_dinner: 0, child_breakfast: 0, child_lunch: 0, child_dinner: 0}
      @durrell = {date: date, cafeteria: 'Durrell', adult_breakfast: 0, adult_lunch: 0, adult_dinner: 0, child_breakfast: 0, child_lunch: 0, child_dinner: 0}
      @rams_horm = {date: date, cafeteria: "Ram's Horn", adult_breakfast: 0, adult_lunch: 0, adult_dinner: 0, child_breakfast: 0, child_lunch: 0, child_dinner: 0}
      Stay.for_date(date).on_campus.includes([{housing_unit: :housing_facility}, :person]).each do |s|
        add_meals(date, s)
      end
      head_counts.add(FoodHeadCount::Row.new(@corbett))
      head_counts.add(FoodHeadCount::Row.new(@durrell))
      head_counts.add(FoodHeadCount::Row.new(@rams_horm))
      head_counts.add(FoodHeadCount::Row.new(@all))
    end
  end

  def add_meals(date, s)
    person = s.person
    # Kids under 5 eat free
    return if person.age < 5

    if person.age > 10
      add_meals_for(date, s, person, :adult)
    else
      add_meals_for(date, s, person, :child)
    end
  end

  def add_meals_for(date, stay, person, age)
    b_key = "#{age}_breakfast".to_sym
    l_key = "#{age}_lunch".to_sym
    d_key = "#{age}_dinner".to_sym
    case
      when date == stay.arrived_at
        # Only dinner
        add_meal(date, stay, person, d_key)
      when date == stay.departed_at
        # No Dinner
        add_meal(date, stay, person, b_key)
        add_meal(date, stay, person, l_key)
      else
        add_meal(date, stay, person, b_key)
        add_meal(date, stay, person, l_key)
        add_meal(date, stay, person, d_key)
    end

  end

  def add_meal(date, stay, person, key)
    @all[key] += 1
    conference = person.conferences.detect { |c| c.start_at <= date && c.end_at >= date }

    # Figure out what cafetria they're eating at and add it there too
    case
      when CORBETT_CONFERENCES.include?(conference) || CORBETT_DORMS.include?(stay.housing_facility.name)
        @corbett[key] += 1
      when RAMS_HORN_DORMS.include?(stay.housing_facility.name)
        @rams_horm[key] += 1
      else
        @durrell[key] += 1
    end
  end

  def head_counts
    @head_counts ||= FoodHeadCount::Table.new
  end

  private

  def date_range
    return 0...0 if stay_date_scope.empty?

    (start_at || Date.today)..(end_at || stay_date_scope.max_date)
  end

  def stay_date_scope
    @stay_date_scope ||= Stay.on_campus
  end
end
