class ImportMinistryHierarchySpreadsheet
  include Interactor

  Error = Class.new(StandardError)

  def call
    reader = open(context.file)

    Ministry.transaction do
      reader.sheets.each { |name| process_sheet(reader.sheet(name)) }
    end
  rescue Error => e
    context.fail! message: e.message
  end

  private

  def open(file)
    path = file.tempfile.path

    case File.extname(file.original_filename)
    when '.ods' then Roo::OpenOffice.new(path)
    when '.csv' then Roo::CSV.new(path)
    when '.xls' then Roo::Excel.new(path)
    when '.xlsx' then Roo::Excelx.new(path)
    else
      raise Error, [
        "Unexpected filename: '#{file.original_filename}'.",
        'Extension must be .ods, .csv, .xls, or .xlsx'
      ].join(' ')
    end
  end

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
        "Row ##{row_index + i}, Column ##{nil_index + 1} references a ministry",
        "('#{row[nil_index]}') which doesn't exist in the system."
      ].join(' ')
    end
  end

  def assign_parents(ministries)
    (1...ministries.size).each do |i|
      ministry = ministries[i]
      parent = ministries[i - 1]

      if parent.id != ministry.id
        ministry.parent = parent
        ministry.save!
      end
    end
  end
end
