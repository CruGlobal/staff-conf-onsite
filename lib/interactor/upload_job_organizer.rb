module Interactor
  # An {Interactor::Organizer} which periodically updates a {UploadJob} record,
  # so that we can update the user-agent on the status of a long-running
  # background job.
  module UploadJobOrganizer
    attr_reader :job

    def self.included(base)
      base.include Interactor::Organizer

      # note: after hooks are only run on success
      base.after do
        job_from_context
        job.update(finished: true, success: true, percentage: 1)
      end
    end

    def job_from_context
      @job ||= context.job.tap do |job|
        raise UploadJobError, 'context.job is missing' if job.nil?
      end
    end
  end
end
