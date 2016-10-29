Rails.application.routes.draw do
  namespace :admin do
    root "users#index"

    resources :users
    resources :places
    resources :events
  end
end
