class Import::ImportPeopleFromSpreadsheet < UploadService
  attr_accessor :skip_first

  def call
    spreadsheet = ReadSpreadsheet.call(job: job, skip_first: skip_first)
    parsed = Import::ParsePeopleFromSpreadsheet.call(job: job,
                                                     sheets: spreadsheet.sheets)
    Import::CreateNewPeopleRecords.call(job: job, imports: parsed.import_people)

    succeed_job
  end
end
