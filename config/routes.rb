Rails.application.routes.draw do
  resources :users do
    post :me, on: :collection
  end
end
