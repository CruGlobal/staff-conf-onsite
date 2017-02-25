require 'webmock'

module Support
  module Cas
    def create_login_user(role = nil)
      factory =
        case role
        when :general then :general_user
        when :finance then :finance_user
        else :admin_user
        end

      create(factory).tap { |u| login_user(u) }
    end

    def login_user(user)
      # {#set_rack_session} comes from the 'rack_session_access' gem
      page.set_rack_session('cas' => {
        'user' => user.email,
        'extra_attributes' => {
          'email' => user.email,
          'first_name' => user.first_name,
          'last_name' => user.last_name,
          'ssoGuid' => user.guid
        }
      })
    end
  end
end
