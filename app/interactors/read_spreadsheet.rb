# This service accepts an uploaded spreadsheet file and converts it into a
# "ruby-representation" of that spreadsheet, which can then be processed by
# other services.
#
# == Spreadsheet file
#
# This service can accept four types of spreadsheets:
#
#  1. OpenOffice (.ods)
#  2. Comma-separated text file (.csv)
#  3. Old Microsoft Excel (.xls)
#  4. New Microsoft Excel (.xlsx)
#
# == Spreadsheet "Ruby Representation"
#
# Abstractly, a "spreadsheet" is a 3D array of strings. A single sheet in a
# spreadsheet is a 2D array of columns and rows of strings, and a spreadsheet
# may have multiple sheets.
#
# This service expects this spreadsheet to be an +Enumerable+ of "sheets",
# where each sheet is an +Enumerable+ or "rows," where each row is an
# +Enumerable+ of "cells" in that row, and each cell is a +String+.
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
