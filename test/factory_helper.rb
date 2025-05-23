module FactoryHelper
  def maybe
    yield if Faker::Boolean.boolean
  end

  def random_future_date(start_date = nil)
    start_date ||= 1.year.from_now
    
    Faker::Date.between(from: start_date, to: start_date + 2.years)
  end
end
