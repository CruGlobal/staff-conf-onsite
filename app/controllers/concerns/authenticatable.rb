# Provides the logic to authenticate the {User current user} via the remote CAS
# service.  ActiveAdmin is configured +config/initializers/active_admin.rb+ to
# call {#authenticate_user!} when no user is currently logged in.
#
# It's not enough for the end-user to have logged in successfully to the remote
# CAS service. They must also have an existing record in the {User} table.
module Authenticatable
  extend ActiveSupport::Concern

  # A {filter}[http://guides.rubyonrails.org/action_controller_overview.html#filters]
  # that checks if the user is currently logged in, on the remote CAS service,
  # and that CAS user has a {User local account} in this system.
  #
  # * If the user is not logged into CAS, they will be redirected to the CAS
  #   login page.
  # * If the logged-in user doesn't have a {User local account}, they will be
  #   shown an error message.

  def consume_okta()
    session_user.sign_into_okta?(params, saml_settings)
    redirect_to('/')
  end

  def authenticate_user!
    if session_user.signed_into_okta?
      if current_user.present?
        after_successful_authentication
      else
        redirect_to unauthorized_login_path
      end
    else
      request = OneLogin::RubySaml::Authrequest.new
      redirect_to(request.create(saml_settings))
      false
    end
  end

  # @return [User] the currently logged-in and authenticated user
  def current_user
    session_user.user_matching_okta_session
  end

  def session_user
    @session_user ||= SessionUser.new(request.session)
  end

  def after_successful_authentication
    current_user.assign_attributes(
      email: session_user.email,
      first_name: session_user.first_name,
      last_name: session_user.last_name
    )

    current_user.save! if current_user.changed?
  end

  private

  def saml_settings
    settings = OneLogin::RubySaml::Settings.new

    # You provide to IDP
    settings.assertion_consumer_service_url = "http://#{request.host_with_port}"
    settings.sp_entity_id                   = ENV['SP_ENTITY_ID']

    # IDP provides to you
    settings.idp_sso_target_url             = ENV['IDP_SSO_TARGET_URL']
    settings.idp_cert                       = ENV['IDP_CERT']

    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    settings.authn_context                  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

    settings
  end

  class SessionUser
    attr_reader :session

    def initialize(session)
      @session = session
    end

    def signed_into_okta?()
      return true unless email == false || email.nil?
    end

    def sign_into_okta?(params, saml_settings)
      return false unless params[:SAMLResponse].present?

      response = OneLogin::RubySaml::Response.new(
        params[:SAMLResponse],
        :settings => saml_settings
      )

      raise response.errors.inspect unless response.is_valid?

      attributes = response.attributes
      email = response.nameid
      allowed_group = attributes.multi(:groups).select { |num| num.include?("Staff_Conference_Onsite:Users:") }
      first_name = attributes[:FirstName]
      last_name = attributes[:LastName]

      group = allowed_group.first.gsub("Staff_Conference_Onsite:Users:", "").downcase.strip      
      raise "Missing group or group not allowed" unless group

      @user = User.find_by(email: email)
      @user ||= User.create!(email: email, first_name: first_name, last_name: last_name, role: group)

      session['email'] = email
      session['first_name'] = first_name
      session['last_name'] = last_name
      session['role'] = group       
      return true
    end

    def user_matching_okta_session
      @user_matching_okta_session ||=
        if (email = session['email'])
          User.find_by(email: email)
        end
    end

    def email
      session['email']
    end

    def first_name
      session['first_name']
    end

    def last_name
      session['last_name']
    end
  end
end
