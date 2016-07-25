Rails.application.routes.draw do
   devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  devise_scope :user do
    get "sign/out" => "devise/sessions#destroy"
  end

  # Static pages
  get "welcome" => "pages#welcome"
  get "sponsorship" => "pages#sponsorship"
  get "slack" => "pages#slack"

  get "sign/in" => "account#sign_in"
  get "sign/up/complete" => "account#sign_up_complete"
  get "profile" => "account#profile"

  scope "profile" do
    get   "edit" => "account#edit"
    get   "settings" => "account#settings"
    patch "settings_update" => "account#settings_update"
  end

  get "/events/places" => "events#places"

  resources :companies

  resources :events do
    collection do
      get "/upcoming" => "events#upcoming"
      get "/past" => "events#past"
    end

    member do
      # Use it for registration to opened events:
      post 'participate'
      # Use it for registration to closed events:
      match 'register', to: 'events#register', via: [:get, :post], as: 'register_to'
      put 'publish'
    end
  end

  resources :users do
    resource :avatars, only: [:create, :destroy], controller: 'users/avatars'
  end

  resources :photos, only: [:index]

  namespace "admin" do
    get "/", to: "users#index"
    resources :users, controller: "users"
    resources :places, controller: "places"
    resources :events, controller: "events"
  end

end
