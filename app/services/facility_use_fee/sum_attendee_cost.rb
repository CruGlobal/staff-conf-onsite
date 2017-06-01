# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class FacilityUseFee::SumAttendeeCost < ChargesService
  attr_accessor :attendee

  def call
    charges[:facility_use] += part1 + part2
    self.cost_adjustments = attendee.cost_adjustments
  end

  def facility_use_fees
    part1 + part2
  end

  private

  def arrival_date
    unless @arrival_date
      @arrival_date = attendee.stays.in_apartment.minimum(:arrived_at)
      @arrival_date ||= attendee.arrived_at if off_campus?
      @arrival_date = UserVariable['FUFSTART'] if @arrival_date && @arrival_date < UserVariable['FUFSTART']
    end
    @arrival_date
  end

  def departure_date
    unless @departure_date
      departure = attendee.stays.in_apartment.maximum(:departed_at)
      departure ||= attendee.departed_at if off_campus?
      @departure_date = departure - 1.day if departure
      @departure_date = UserVariable['FUFEND'] if @departure_date && @departure_date > UserVariable['FUFEND']
    end
    @departure_date
  end

  def part1
    if arrival_date && arrival_date < split_date
      part1 = Money.us_dollar((split_date - arrival_date).to_i * UserVariable['FUFP1'])
      # Subtrack out dorm stays
      attendee.stays.in_dormitory.where('arrived_at < ?', split_date).each do |stay|
        part1 -= ([stay.departed_at, split_date].min - stay.arrived_at).to_i * UserVariable['FUFP1']
      end
      part1
    else
      Money.empty
    end
  end

  def part2
    if departure_date && departure_date >= split_date
      part2 = Money.us_dollar((departure_date - split_date).to_i * UserVariable['FUFP2'])
      # Subtrack out dorm stays
      attendee.stays.in_dormitory.where('departed_at > ?', split_date).each do |stay|
        part2 -= (stay.departed_at - [stay.arrived_at, split_date].max).to_i * UserVariable['FUFP2']
      end
      part2
    else
      Money.empty
    end
  end

  def split_date
    UserVariable['FUFSPLIT']
  end

  def off_campus?
    %w(apartment self_provided).include?(attendee.family.housing_preference.housing_type)
  end
end
