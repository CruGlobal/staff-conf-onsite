# Provides the logic to authenticate the user via the remote CAS service.
# ActiveAdmin is configured ([file:config/initializers/active_admin.rb]) to
# call {#authenticate_user!} when no user is currently logged in.
#
# It's not enough for the end-user to have logged in successfully to the remote
# CAS service. They must also have an existing record in the {User} table.
module Authenticatable
  extend ActiveSupport::Concern

  def authenticate_user!
    if signed_into_cas?
      if user_matching_cas_session.present?
        after_successful_authentication
      else
        redirect_to unauthorized_login_path
      end
    else
      # envoke rack-cas redirect for user authentication
      head status: :unauthorized
      return false
    end
  end

  # @return [User] the currently logged-in and authenticated user
  def current_user
    @current_user ||=
      if (guid = cas_attr('theKeyGuid'))
        User.find_by(guid: guid)
      end
  end

  def cas_attr(attr)
    cas_extra_attributes.try(:[], attr)
  end

  def cas_email
    request.session['cas'].try(:[], 'user')
  end

  private

  # @return [Boolean] if the user has signed into the remote CAS service
  def signed_into_cas?
    cas_attr('theKeyGuid').present?
  end

  # @return [User] the local user matching the GUID passed from the remote CAS
  #   service
  def user_matching_cas_session
    @user_matching_cas_session ||=
      if (guid = cas_attr('theKeyGuid'))
        User.find_by(guid: guid)
      end
  end

  def cas_extra_attributes
    request.session['cas'].try(:[], 'extra_attributes')
  end

  def after_successful_authentication
    user_matching_cas_session.assign_attributes(
      email: cas_email,
      first_name: cas_attr('firstName'),
      last_name: cas_attr('lastName')
    )

    if user_matching_cas_session.changed?
      user_matching_cas_session.save
    end
  end
end
