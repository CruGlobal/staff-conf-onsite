module Interactor
  UploadJobError = Class.new(StandardError)

  # An {Interactor} which periodically updates a {UploadJob} record, so that we
  # can update the user-agent on the status of a long-running background job.
  module UploadJob
    attr_reader :job

    def self.included(base)
      base.include Interactor
      base.extend ClassMethods

      base.before do
        job_from_context
        update_job_stage
      end
    end

    module ClassMethods
      # Set/Get a descriptive name for an Interactor, so we can better describe
      # the current stage the job is processing
      def job_stage(stage = nil)
        @job_stage = stage if stage.present?
        @job_stage || name.titleize
      end
    end

    def job_from_context
      @job ||= context.job.tap do |job|
        raise UploadJobError, 'context.job is missing' if job.nil?
      end
    end

    def fail_job!(message: nil)
      if message.present?
        job.update!(finished: true, success: false, html_message: message)
        context.fail! message: message
      else
        context.fail!
      end
    end

    def update_job_stage
      job.update!(stage: self.class.job_stage)
    end

    def update_percentage(percentage)
      local_job = job
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          local_job.update!(percentage: percentage)
        end
      end
    end

    def unlink_job_upload!
      job.unlink_file!
    end
  end
end
