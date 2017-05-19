class ImportPeopleFromSpreadsheetJob < ActiveJob::Base
  queue_as :default

  def perform(upload_job_id)
    job = UploadJob.find(upload_job_id)
    return if job.started?

    Import::ImportPeopleFromSpreadsheet.call(job: job)
  rescue => e
    (job || UploadJob.find_by(id: upload_job_id))&.fail!(e.message)
  rescue Exception => e
    job.fail!(e.message)
  ensure
    job&.remove_file!
  end
end
