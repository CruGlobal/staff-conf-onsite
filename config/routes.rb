Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get '/unauthorized', to: 'login#unauthorized', as: :unauthorized_login
end
