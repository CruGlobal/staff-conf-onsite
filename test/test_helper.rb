ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'
require 'minitest/reporters'
Minitest::Reporters.use!

FactoryGirl.find_definitions

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Support::Moneyable

  def assert_permit(user, record, action)
    msg = "User #{user.inspect} should be permitted to #{action} #{record.inspect}, but isn't permitted"
    assert permit(user, record, action), msg
  end

  def refute_permit(user, record, action)
    msg = "User #{user.inspect} should NOT be permitted to #{action} #{record.inspect}, but is permitted"
    refute permit(user, record, action), msg
  end

  def permit(user, record, action)
    cls = self.class.to_s.gsub(/Test/, 'Policy')
    cls.constantize.new(user, record).public_send("#{action.to_s}?")
  end

  def create_users
    @general_user = create :general_user
    @finance_user = create :finance_user
    @admin_user = create :admin_user
  end
end
