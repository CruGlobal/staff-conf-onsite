require Rails.root.join('config', 'initializers', 'redis').to_s

redis_config = { url: Redis.current.client.id,
                 namespace: "sco:#{Rails.env}:sidekiq" }

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

Sidekiq.configure_server do |config|
  Sidekiq::Logging.logger.level = Logger::FATAL unless Rails.env.development?
  Rails.logger = Sidekiq::Logging.logger
  config.redis = redis_config
end
