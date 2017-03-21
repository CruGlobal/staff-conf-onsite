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
    all_units = housing_facility.housing_units.to_a
    names = parse_sheets
    new_names = names - all_units.map(&:name)

    HousingFacility.transaction do
      possibly_delete_existing(all_units, names)
      create_units(new_names)
    end
  rescue Error => e
    context.fail! message: e.message
  end

  private

  def parse_sheets
    context.sheets.flat_map do |rows|
      rows.flat_map { |row| row.compact.map(&method(:parse_cell)) }
    end.compact.uniq
  end

  def parse_cell(cell)
    case cell
    when Numeric
      cell.to_i.to_s
    else
      cell.to_s.strip
    end
  end

  def possibly_delete_existing(units, names_to_keep)
    if context.delete_existing.present?
      remove_units = units.reject { |u| names_to_keep.include?(u.name) }
      remove_units.each(&:destroy!)
    end
  end

  def create_units(names)
    names.map { |name| create_unit(name) }.each(&:save!)
  end

  def create_unit(name)
    housing_facility.housing_units.build(name: name)
  end

  def housing_facility
    @housing_facility ||=
      HousingFacility.includes(:housing_units).find(context.housing_facility_id)
  end
end
