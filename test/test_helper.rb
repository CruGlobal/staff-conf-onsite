ENV['RAILS_ENV'] ||= 'test'

# Code coverage is enabled by default when running tests.
# Since it slows down test running, it's possible to disable by adding
# CODE_COVERAGE=disable into your local .env.test file (this file is not
# tracked in git).
unless ENV['CODE_COVERAGE'] == 'disable'
  # Must appear before the Application code is required
  require 'simplecov'
  SimpleCov.start
end

require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is not test
abort("The Rails environment is running in #{Rails.env} mode!") unless Rails.env.test?

require 'rails/test_help'
require 'webmock/minitest'
require 'minitest/rails/capybara'
require 'rack_session_access/capybara'
require 'capybara-screenshot/minitest'
require 'minitest/reporters'
require_relative '../db/seminaries'
require 'vcr'
require 'mocha/minitest'
require 'sidekiq/testing'

Minitest::Reporters.use!

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

Support::StubCas.stub_requests

FactoryGirl.find_definitions

Minitest.after_run { DatabaseCleaner.clean_with :truncation }

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Support::UserVariable
  include Support::DatabaseCleanerHooks

  setup { VCR.turn_off! }
end

class ControllerTestCase < ActionController::TestCase; end

class IntegrationTest < Capybara::Rails::TestCase
  include Support::ActiveAdmin
  include Support::Authentication
  include Support::Javascript
  include Capybara::Screenshot::MiniTestPlugin

  teardown { Capybara.use_default_driver }
end

class ModelTestCase < ActiveSupport::TestCase
  include Support::Authentication
  include Support::Moneyable
end

class ServiceTestCase < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup { VCR.turn_on! }
end

class JobTestCase < ActiveJob::TestCase
  include ActionDispatch::TestProcess
end

class MailTestCase < ActionMailer::TestCase
  include ActionDispatch::TestProcess
end
