class ImportHousingUnitsSpreadsheetJob < ActiveJob::Base
  queue_as :default

  def perform(upload_job_id, skip_first)
    job = UploadJob.find(upload_job_id)
    ImportHousingUnitsSpreadsheet.call(job: job, skip_first: skip_first)
  end
end
