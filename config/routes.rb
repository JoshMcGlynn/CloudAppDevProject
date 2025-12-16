Rails.application.routes.draw do
  root "hotels#index"
  
  resources :hotels do
    resources :rooms
  end

  #authentication routes (API)
  resources :users, only: [:create]
  post "/login", to: "sessions#create"
end
