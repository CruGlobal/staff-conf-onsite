require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  authenticated_constraint = lambda do |request|
    Authenticatable::SessionUser.new(request.session).signed_into_cas?
  end

  constraints authenticated_constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/housing_units_list', to: 'housing_units_list#index'
  get '/unauthorized', to: 'login#unauthorized', as: :unauthorized_login
  get '/monitors/lb', to: 'monitors#service_online'

  get  '/precheck_email',           to: 'precheck_emails#new'
  get  '/precheck_email/confirmed', to: 'precheck_emails#confirmed', as: :precheck_email_confirmed
  get  '/precheck_email/rejected',  to: 'precheck_emails#rejected', as: :precheck_email_rejected
  post '/precheck_email/confirm',   to: 'precheck_emails#confirm', as: :precheck_email_confirm
  post '/precheck_email/reject',    to: 'precheck_emails#reject', as: :precheck_email_reject
end
