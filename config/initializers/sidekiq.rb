require Rails.root.join('config', 'initializers', 'redis').to_s

Sidekiq.configure_client do |config|
  config.redis = { url: Redis.current.client.id,
                   namespace: "MPDX:#{Rails.env}:resque" }
end

Sidekiq.configure_server do |config|
  Sidekiq::Logging.logger.level = Logger::FATAL unless Rails.env.development?
  Rails.logger = Sidekiq::Logging.logger
  config.redis = { url: Redis.current.client.id,
                   namespace: "Staff-Conf:#{Rails.env}:resque" }
end
