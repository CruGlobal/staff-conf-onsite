require 'sidekiq/web'

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/sidekiq'

  get '/housing_units_list', to: 'housing_units_list#index'
  get '/unauthorized', to: 'login#unauthorized', as: :unauthorized_login
  get '/monitors/lb', to: 'monitors#service_online'

  get  '/precheck_email',           to: 'precheck_emails#new'
  get  '/precheck_email/rejected',  to: 'precheck_emails#rejected', as: :precheck_email_rejected
  post '/precheck_email/reject',    to: 'precheck_emails#reject', as: :precheck_email_reject
end
