Rails.application.routes.draw do

  resource :user_registration, only: [:new, :create]
  resource :user_session, only: [:new, :create, :destroy]

  get 'oauth/callback' => 'oauths#callback'
  get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider

  resources :events, except: [:destroy]

  root to: 'events#index'
end
