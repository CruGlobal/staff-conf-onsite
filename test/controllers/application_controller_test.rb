require 'test_helper'

class TestApplicationController < ApplicationController
  before_action :authenticate_user!, only: :test_action

  def test_action
    head :ok
  end
end

class TestApplicationControllerTest < ActionController::TestCase
  setup do
    @first_name = 'Foo'
    @last_name = 'Bar'
    @email = 'foo-bar@example.com'

    Rails.application.routes.send :eval_block,
      proc { get 'test_action' => 'test_application#test_action' }
  end

  test 'login with Okta SAML' do
    @user = create :user, email: @email

    refute @controller.current_user, 'user should not be logged in'

    @request.session.merge!(
      'email' => @email,
      'first_name' => @first_name,
      'last_name' => @last_name
    )

    get :test_action

    assert_response :ok
    assert_equal @user, @controller.current_user.reload
    assert_equal @first_name, @controller.current_user.first_name
    assert_equal @last_name, @controller.current_user.last_name
    assert_equal @email, @controller.current_user.email
  end

  test 'failed login with Okta SAML: user not found' do
    refute @controller.current_user, 'user should not be logged in'

    @request.session.merge!(
      'email' => 'unknown-user@example.com',
      'first_name' => @first_name,
      'last_name' => @last_name
    )

    get :test_action

    assert_redirected_to unauthorized_login_path
  end

  test 'not logged into Okta SAML' do
    clear_session!

    get :test_action

    assert_response :redirect
    assert_match /https:\/\/.*okta.*sso/, response.redirect_url # optional check if you want to match SAML redirect
  end

  private

  def clear_session!
    @request.session.clear
  end
end
