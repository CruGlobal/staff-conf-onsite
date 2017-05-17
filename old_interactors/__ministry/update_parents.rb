# This service accepts a "ruby representation" of a spreadsheet containing
# information about the hierarchy of {Ministry Ministries} in the system. Each
# row describes a single chain of Grandparent-parent-child-etc. relationship,
# where each cell in the row contains the +code+ of a +Ministry+ and each
# Ministry is the parent of the +Ministry+ in the cell to its right.
#
# The {ReadSpreadsheet} service can convert an uploaded file into the
# representation expected by this service. See its documentation for a
# description of the spreadsheet "ruby representation."
class Ministry::UpdateParents
  include Interactor::UploadJob

  Error = Class.new(StandardError)

  job_stage 'Update Ministry Hierarchies'

  def call
    Ministry.transaction do
      context.sheets.each { |sheet| process_sheet(sheet) }
      ministries.each(&:save!)
    end
  rescue Error => e
    fail_job! message: e.message
  end

  private

  def process_sheet(sheet)
    count = sheet.count

    sheet.each_with_index do |row, row_index|
      row = row.map(&:strip).select(&:present?)
      next if row.size < 2

      update_percentage(row_index / count) if row_index.modulo(100).zero?

      ministries = row_to_ministries(row)
      assert_ministries!(row, row_index, ministries)

      assign_parents(ministries)
    end
  end

  def row_to_ministries(row)
    row.map { |code| find_by(code: code) }
  end

  def find_by(code:)
    ministries.find { |m| m.code == code }
  end

  def ministries
    @ministries ||= Ministry.all.to_a
  end

  def assert_ministries!(row, row_index, ministries)
    nil_index = ministries.index(nil)
    return unless nil_index.present?

    raise Error, [
      "Row ##{row_index + 1}, Column ##{nil_index + 1} references a ministry",
      "('#{row[nil_index]}') which doesn't exist in the system."
    ].join(' ')
  end

  def assign_parents(ministries)
    (1...ministries.size).each do |i|
      ministry = ministries[i]
      parent = ministries[i - 1]

      ministry.parent = parent unless parent.id == ministry.id
    end
  end
end
