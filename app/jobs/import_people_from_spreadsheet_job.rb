class ImportPeopleFromSpreadsheetJob < ActiveJob::Base
  queue_as :default

  def perform(upload_job_id)
    job = UploadJob.find(upload_job_id)
    Import::ImportPeopleFromSpreadsheet.call(job: job)
  end
end
