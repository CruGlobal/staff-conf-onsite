ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'
require 'minitest/rails/capybara'
require 'rack_session_access/capybara'
require 'minitest/reporters'

Minitest::Reporters.use!

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

Support::StubCas.stub_requests
FactoryGirl.find_definitions

class ControllerTestCase < ActionController::TestCase
  include FactoryGirl::Syntax::Methods
end

class IntegrationTest < Capybara::Rails::TestCase
  include FactoryGirl::Syntax::Methods
  include Support::ActiveAdmin
  include Support::Authentication
  include Support::Javascript

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

  self.use_transactional_fixtures = false
  before(:each) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true, reset_ids: false }
    DatabaseCleaner.start
  end
  after(:each)  { DatabaseCleaner.clean }
end

class InteractorTestCase < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Support::Interactor

  self.use_transactional_fixtures = false
  before(:each) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true, reset_ids: false }
    DatabaseCleaner.start
  end
  after(:each)  { DatabaseCleaner.clean }
end
