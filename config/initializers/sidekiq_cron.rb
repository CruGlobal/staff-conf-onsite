# frozen_string_literal: true

nightly_cron_schedule = '0 1 * * *'

cron_jobs_hash = ActiveSupport::HashWithIndifferentAccess.new(
  production: {
    'Nightly Precheck Mailer' => {
      class: NightlyPrecheckMailerJob.name,
      cron:  nightly_cron_schedule
    }
  },

  staging: {
  }
)

Sidekiq::Cron::Job.load_from_hash!(cron_jobs_hash[Rails.env]) if cron_jobs_hash[Rails.env]
