Rails.application.routes.draw do
  resources :games
  resources :users
  post '/auth/login', to: 'authentication#login'
end
