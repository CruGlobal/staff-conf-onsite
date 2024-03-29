require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'rack-cas/session_store/active_record'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative '../lib/log/logger'
module CruConference
  class Application < Rails::Application
    # Send all logs to stdout, which docker reads and sends to datadog.
    config.logger = Log::Logger.new($stdout) unless Rails.env.test? # we don't need a logger in test env

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Mountain Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'admin', 'concerns')
    config.autoload_paths << Rails.root.join('app', 'services')

    redis_conf = YAML.safe_load(ERB.new(File.read(Rails.root.join("config", "redis.yml"))).result, [Symbol], [], true)["cache"]
    redis_conf[:url] = "redis://" + redis_conf[:host] + "/" + redis_conf[:db].to_s
    config.cache_store = :redis_store, redis_conf

    # gem 'rack-cas'
    config.rack_cas.server_url = ENV['CAS_URL']
    config.rack_cas.session_store = RackCAS::ActiveRecordStore

    config.generators do |g|
      g.test_framework :test_unit, fixture: false
    end
  end
end
