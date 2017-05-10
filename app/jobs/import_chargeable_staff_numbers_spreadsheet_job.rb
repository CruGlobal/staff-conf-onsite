class ImportChargeableStaffNumbersSpreadsheetJob < ActiveJob::Base
  queue_as :default

  def perform(upload_job_id, delete_existing, skip_first)
    job = UploadJob.find(upload_job_id)
    ImportChargeableStaffNumbersSpreadsheet.call(
      job: job, delete_existing: delete_existing, skip_first: skip_first
    )
  end
end
