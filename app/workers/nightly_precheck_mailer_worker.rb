class NightlyPrecheckMailerWorker
  include Sidekiq::Worker

  def perform
    NightlyPrecheckMailerJob.perform_later
  end
end
