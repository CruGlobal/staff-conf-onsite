Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get '/unauthorized', to: 'login#unauthorized', as: :unauthorized_login
  get '/monitors/lb', to: 'monitors#service_online'
end
