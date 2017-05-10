module Import
  # == Context Input
  #
  # [+context.file+ [+File+]]
  class ParsePeopleFromSpreadsheet
    include Interactor::UploadJob

    job_stage 'Scan Spreadsheet Rows for New People'

    def call
      context.import_people = context.sheets.flat_map(&method(:process_sheet))
    end

    private

    def process_sheet(sheet)
      # hashes = sheet_to_hashes(sheet)
      count = sheet.count

      # hashes.each_with_index.map do |row, index|
      each_row_with_index(sheet).map do |row, index|
        next if index.zero?
        update_percentage(index / count) if index.modulo(100).zero?
        Import::Person.new(row)
      end.compact
    end

    # uses the cells from the first row to map columns to hash keys
    def each_row_with_index(sheet)
      sheet.each(Import::Person::SPREADSHEET_TITLES).each_with_index
    end
  end
end
