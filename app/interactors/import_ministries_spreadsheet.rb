class ImportMinistriesSpreadsheet
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
    sheet.each_with_index do |row, i|
      row = row.map(&:strip).select(&:present?)

      if row.size < 2
        raise Error, "Row ##{i + 1} has too few columns. '#{row.join(',')}'"
      end

      create_or_update(row[0], row[1])
    end
  end

  def create_or_update(code, name)
    if (existing = find_by_code(code))
      existing.name = name
      existing.save!
    else
      Ministry.create!(code: code, name: name)
    end
  end

  def find_by_code(code)
    ministries.find { |m| m.code == code }
  end

  def ministries
    @ministries ||= Ministry.all.to_a
  end
end
