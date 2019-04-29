# frozen_string_literal: true

cron_jobs_hash = ActiveSupport::HashWithIndifferentAccess.new(
  production: {
  },

  staging: {
  }
)

Sidekiq::Cron::Job.load_from_hash!(cron_jobs_hash[Rails.env]) if cron_jobs_hash[Rails.env]
