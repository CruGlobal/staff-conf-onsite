require 'redis'
require 'datadog/statsd'

redis_conf = YAML.safe_load(ERB.new(File.read(Rails.root.join("config", "redis.yml"))).result, [Symbol], [], true)["sidekiq"]

redis_settings = {url: Redis.new(redis_conf).id}

Sidekiq.configure_client do |config|
  config.redis = redis_settings
end

if Sidekiq::Client.method_defined? :reliable_push!
  Sidekiq::Client.reliable_push!
end

Sidekiq.configure_server do |config|
  Sidekiq.logger.level = Logger::FATAL unless Rails.env.development?

  Rails.logger = Sidekiq.logger

  config.super_fetch!
  config.reliable_scheduler!
  config.redis = redis_settings
end

Sidekiq.default_job_options  = {
  backtrace: false
}

if ENV["AWS_EXECUTION_ENV"].present?
  Sidekiq::Pro.dogstatsd = -> { Datadog::Statsd.new socket_path: "/var/run/datadog/dsd.socket" }
end
