Rails.application.routes.draw do
  root "hotels#index"
  
  resources :hotels do
    resources :rooms
  end
end
