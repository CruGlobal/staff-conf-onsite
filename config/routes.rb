require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  authenticated_constraint = lambda do |request|
    Authenticatable::SessionUser.new(request.session).signed_into_okta?
  end

  constraints authenticated_constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/housing_units_list', to: 'housing_units_list#index'
  get '/unauthorized', to: 'login#unauthorized', as: :unauthorized_login
  get '/monitors/lb', to: 'monitors#service_online'

  post '/', to: "application#consume_okta"

  post '/child_form_approval/:uid', to: 'external_forms#approve', as: :approve_external_form
  delete '/child_form_approval/:uid', to: 'external_forms#disapprove', as: :disapprove_external_form

  namespace :precheck do
    get ':token', to: 'status#show', as: :status
    post ':token/confirmation', to: 'confirmation#create', as: :confirmation
    post ':token/rejection', to: 'rejection#create', as: :rejection
  end

  # Check-in routes using RESTful conventions
  get '/arrival-scan', to: 'checkins#new', as: :new_checkin
  post '/arrival-scan/confirm', to: 'checkins#confirm_scan', as: :confirm_scan_checkins
  post '/arrival-scan', to: 'checkins#create', as: :checkins
end
