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
require 'minitest/reporters'
require_relative '../db/seminaries'
require 'vcr'
require 'mocha/minitest'

Minitest::Reporters.use!

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

Support::StubCas.stub_requests
FactoryGirl.find_definitions

class ControllerTestCase < ActionController::TestCase
  include FactoryGirl::Syntax::Methods
  include Support::UserVariable
end

class IntegrationTest < Capybara::Rails::TestCase
  include FactoryGirl::Syntax::Methods
  include Support::ActiveAdmin
  include Support::Authentication
  include Support::Javascript
  include Support::UserVariable

  self.use_transactional_fixtures = false
  before(:each) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true, reset_ids: false }
    DatabaseCleaner.start
  end
  after(:each) do
    Capybara.use_default_driver
    DatabaseCleaner.clean
  end
end

class ModelTestCase < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Support::Authentication
  include Support::Moneyable
  include Support::UserVariable

  self.use_transactional_fixtures = false
  before(:each) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true, reset_ids: false }
    DatabaseCleaner.start
  end
  after(:each)  { DatabaseCleaner.clean }
end

class ServiceTestCase < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Support::UserVariable
  include ActionDispatch::TestProcess

  self.use_transactional_fixtures = false
  before(:each) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true, reset_ids: false }
    DatabaseCleaner.start
  end
  after(:each)  { DatabaseCleaner.clean }
end

class JobTestCase < ActiveJob::TestCase
  include FactoryGirl::Syntax::Methods
  include Support::UserVariable
  include ActionDispatch::TestProcess

  self.use_transactional_fixtures = false
  before(:each) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true, reset_ids: false }
    DatabaseCleaner.start
  end
  after(:each)  { DatabaseCleaner.clean }
end
