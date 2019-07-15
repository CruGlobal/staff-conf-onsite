require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'rack-cas/session_store/active_record'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative '../lib/log/logger'
module CruConference
  class Application < Rails::Application
    # Enable ougai
    config.logger = Log::Logger.new(Rails.root.join('log', 'datadog.log'))
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

    config.cache_store = :redis_store, {
      host: ENV['REDIS_PORT_6379_TCP_ADDR'],
      namespace: "sco:#{Rails.env}:cache_store",
      expires_in: 1.hour
    }

    # gem 'rack-cas'
    config.rack_cas.server_url = ENV['CAS_URL']
    config.rack_cas.session_store = RackCAS::ActiveRecordStore

    config.generators do |g|
      g.test_framework :test_unit, fixture: false
    end
  end
end
