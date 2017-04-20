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

  RowRecord = Struct.new(:record, :import)
  Error = Class.new(StandardError)

  before do
    @housing_facilities = HousingFacility.all.includes(:housing_units)
  end

  # Create each {HousingUnit} referenced in the given sheets.
  #
  # @return [Interactor::Context]
  def call
    import_models = parse_sheets
    row_records = build_models(import_models)
    save_all!(row_records)
  rescue Error => e
    context.fail! message: e.message
  end

  private

  def parse_sheets
    context.sheets.flat_map do |rows|
      rows.each_with_index.map(&method(:create_from_row))
    end
  end

  def create_from_row(row, index)
    row_number = index + (context.skip_first ? 2 : 1)
    Import::HousingUnit.from_array(row_number, row)
  end

  def build_models(import_models)
    import_models.map do |import|
      begin
        facility = find_facility(import.facility_name)
        unless import.exists_in?(facility)
          RowRecord.new(
            import.build_record(facility),
            import
          )
        end
      rescue => e
        raise Error, format('Row #%d: %p', import.row, e.message)
      end
    end.compact
  end

  def find_facility(name)
    @housing_facilities.find { |f| f.name == name }.tap do |facility|
      if facility.nil?
        raise Error, format('Could not find HousingFacility: %s', name)
      end
    end
  end

  def save_all!(row_records)
    HousingFacility.transaction do
      row_records.each do |row_record|
        record = row_record.record
        begin
          record.save!
        rescue => e
          raise Error, format('Row #%d: Could not persist %s, %p. %s',
                              row_record.import.row, record.class.name,
                              record.audit_name, e.message)
        end
      end
    end
  end
end
