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

  namespace :precheck do
    get ':token', to: 'status#show', as: :status
    post ':token/confirmation', to: 'confirmation#create', as: :confirmation
    post ':token/rejection', to: 'rejection#create', as: :rejection
  end
end
