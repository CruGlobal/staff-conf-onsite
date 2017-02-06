# The {ReadSpreadsheet} service can convert an uploaded file into the
# representation expected by this service. See its documentation for a
# description of the spreadsheet "ruby representation."
#
# == Context Input
#
# [+context.housing_facility_id+ [+Fixnum+]]
#   the ID of the {HousingFacility} to add the new units to
# [+context.sheets+ [+Enumerable+]]
#   a ruby-representation of the uploaded spreadsheet file.  See
#   {ReadSpreadsheet}
class CreateHousingUnits
  include Interactor

  Error = Class.new(StandardError)

  # Create each {HousingUnit} referenced in the given sheets.
  #
  # @return [Interactor::Context]
  def call
    HousingFacility.transaction do
      context.sheets.each { |rows| parse_units(rows) }
      housing_facility.housing_units.each(&:save!)
    end
  rescue Error => e
    context.fail! message: e.message
  end

  private

  def parse_units(rows)
    rows.each do |row|
      row = row.compact.map(&:strip).select(&:present?)

      row.each { |name| create_unit(name) }
    end
  end

  def create_unit(name)
    housing_facility.housing_units.build(name: name) unless find_unit(name)
  end

  def find_unit(name)
    housing_facility.housing_units.find { |u| u.name == name }
  end

  def housing_facility
    @housing_facility ||=
      HousingFacility.includes(:housing_units).find(context.housing_facility_id)
  end
end
