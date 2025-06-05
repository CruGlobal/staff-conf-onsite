# frozen_string_literal: true
Rails.application.config.after_initialize do
  # We want the nightly precheck email to be sent at 9am mountain time (11am eastern).
  nightly_cron_schedule = '0 9 * * *'

  cron_jobs_hash = ActiveSupport::HashWithIndifferentAccess.new(
    production: {
      'Nightly PreCheck Mailer (Production)' => {
        class: 'NightlyPrecheckMailerWorker',
        cron:  nightly_cron_schedule
      }
    },

    staging: {
      'Nightly PreCheck Mailer (Staging)' => {
        class: 'NightlyPrecheckMailerWorker',
        cron:  nightly_cron_schedule
      }
    }
  )

  Sidekiq::Cron::Job.load_from_hash!(cron_jobs_hash[Rails.env]) if cron_jobs_hash[Rails.env]
end
