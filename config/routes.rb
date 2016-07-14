Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  devise_scope :user do
    get "sign/out" => "devise/sessions#destroy"
  end

  get "sign/in" => "account#sign_in"
  get "sign/up/complete" => "account#sign_up_complete"
  get "profile" => "account#profile"

  resources :users, :companies

  resources :events do
    member do
      # Use it for registration to opened events:
      post 'participate'
      # Use it for registration to closed events:
      match 'register', to: 'events#register', via: [:get, :post], as: 'register_to'
      put 'publish'
    end
  end
end
