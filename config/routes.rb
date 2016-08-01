Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get "sign_in" => "account#sign_in"
    get "sign_out" => "devise/sessions#destroy"
  end

  # Static pages
  %w(welcome sponsorship slack).each do |page_name|
    get page_name => "pages##{page_name}"
  end

  get "sign_up/complete" => "account#sign_up_complete"
  get "profile" => "account#profile"

  scope "profile" do
    get   "edit" => "account#edit", as: :edit_profile
    get   "settings" => "account#settings", as: :profile_settings
    patch "settings_update" => "account#settings_update"
  end

  resources :companies

  resources :events do
    collection do
      get "/upcoming" => "events#upcoming"
      get "/past" => "events#past"
    end

    member do
      # Use it for registration to opened events:
      post "participate"
      # Use it for registration to closed events:
      match "register", to: "events#register", via: [:get, :post], as: "register_to"
      # Use it for revoke user registration
      delete "revoke_participation", to: "events#revoke_participation"

      put "publish"
    end
  end

  resources :users do
    collection do
      get "/active" => "users#active"
      get "/recent" => "users#recent"
    end
    resource :avatars, only: [:create, :destroy], controller: "users/avatars"
  end

  resources :photos, only: [:index]

  resources :places, only: [:index] do
    get "/find" => "places#find", on: :collection
  end

  namespace "admin" do
    get "/", to: "users#index"
    resources :users, controller: "users"
    resources :places, controller: "places"
    resources :events, controller: "events"
  end

  # Errors
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
