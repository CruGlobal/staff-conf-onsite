class UpdateMinistryParents
  include Interactor

  Error = Class.new(StandardError)

  def call
    Ministry.transaction do
      context.sheets.each { |sheet| process_sheet(sheet) }
      ministries.each(&:save!)
    end
  rescue Error => e
    context.fail! message: e.message
  end

  private

  def process_sheet(sheet)
    sheet.each_with_index do |row, row_index|
      row = row.map(&:strip).select(&:present?)
      next if row.size < 2

      ministries = row_to_ministries(row)
      assert_ministries!(row, row_index, ministries)

      assign_parents(ministries)
    end
  end

  def row_to_ministries(row)
    row.map { |code| find_by_code(code) }
  end

  def find_by_code(code)
    ministries.find { |m| m.code == code }
  end

  def ministries
    @ministries ||= Ministry.all.to_a
  end

  def assert_ministries!(row, row_index, ministries)
    if (nil_index = ministries.index(nil))
      raise Error, [
        "Row ##{row_index + 1}, Column ##{nil_index + 1} references a ministry",
        "('#{row[nil_index]}') which doesn't exist in the system."
      ].join(' ')
    end
  end

  def assign_parents(ministries)
    (1...ministries.size).each do |i|
      ministry = ministries[i]
      parent = ministries[i - 1]

      ministry.parent = parent unless parent.id == ministry.id
    end
  end
end
