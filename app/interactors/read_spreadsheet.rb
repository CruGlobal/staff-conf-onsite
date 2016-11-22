class ReadSpreadsheet
  include Interactor

  Error = Class.new(StandardError)
  TRUE_VALUES = ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES

  def call
    reader = open(context.file)
    sheets = reader.sheets.map { |name| reader.sheet(name) }

    context.sheets =
      if skip_first_row?
        sheets.map { |sheet| sheet.drop(1) }
      else
        sheets
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

  def skip_first_row?
    TRUE_VALUES.include?(context.skip_first)
  end
end
