module Import
  # == Context Input
  #
  # [+context.file+ [+File+]]
  class ParsePeopleFromSpreadsheet
    include Interactor

    def call
      context.import_people = context.sheets.flat_map(&method(:process_sheet))
    end

    private

    def process_sheet(sheet)
      sheet_to_hashes(sheet).map { |row| Import::Person.new(row) }
    end

    # uses the cells from the first row to map columns to hash keys
    def sheet_to_hashes(sheet)
      sheet.parse(Import::Person::SPREADSHEET_TITLES)[1..-1]
    end
  end
end
