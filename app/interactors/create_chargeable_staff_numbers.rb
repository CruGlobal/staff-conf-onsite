# This service accepts a "ruby representation" of a spreadsheet containing a
# list of {Person#staff_number staff numbers}. If a {ChargeableStaffNumber}
# already exists with the given +value+, that row is ignored.
#
# The {ReadSpreadsheet} service can convert an uploaded file into the
# representation expected by this service. See its documentation for a
# description of the spreadsheet "ruby representation."
#
# == Context Input
#
# [+context.sheets+ [+Enumerable+]]
#   a ruby-representation of the uploaded spreadsheet file.  See
#   {ReadSpreadsheet}
#
# [+context.delete_existing+ [Boolean]]
#   whether existing {ChargeableStaffNumber} records should first be destroyed
class CreateChargeableStaffNumbers
  include Interactor

  Error = Class.new(StandardError)
  TRUE_VALUES = ReadSpreadsheet::TRUE_VALUES

  # @return [Interactor::Context]
  def call
    ChargeableStaffNumber.transaction do
      ChargeableStaffNumber.delete_all if delete_existing?

      numbers = context.sheets.flat_map { |rows| parse_staff_number_rows(rows) }
      numbers.each(&:save!)
    end
  rescue Error => e
    context.fail! message: e.message
  end

  private

  def delete_existing?
    TRUE_VALUES.include?(context.delete_existing)
  end

  def scope
    @scope ||= ChargeableStaffNumber.all
  end

  def parse_staff_number_rows(rows)
    rows.map do |row|
      staff_number = row[0].to_s.strip

      unless staff_number.blank?
        scope.find_or_create_by(staff_number: staff_number)
      end
    end.compact
  end
end
