Rails.application.routes.draw do
  resources :users
  get 'me', to: 'users#show'
  post 'auth/login', to: 'authentication#login'
end