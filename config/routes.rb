Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth" }

  devise_scope :user do
    get "sign_in", to: "users/profile#sign_in"
    get "sign_out", to: "devise/sessions#destroy"
  end

  # Static pages
  %w(welcome about).each do |page_name|
    get page_name, to: "pages##{page_name}"
  end

  get "sign_up/complete", to: "users/profile#sign_up_complete"
  get "profile", to: "users/profile#profile"

  scope "profile" do
    get   "edit", to: "users/profile#edit", as: :edit_profile
    get   "settings", to:  "users/profile#settings", as: :profile_settings
    patch "settings_update", to: "users/profile#settings_update"
  end

  resources :companies

  resources :events do
    collection do
      get "/upcoming", to: "events#upcoming"
      get "/past", to: "events#past"
      get "/unpublished", to: "events#unpublished"
    end

    member do
      # Events visits
      get "visits/:hash", to: "events/visits#index", as: :visits_for
      put "visits/:hash/mark", to: "events/visits#mark"

      # Use it for registration to opened events:
      get "participate", to: "events/participations#participate"

      # Use it for registration to closed events:
      get "registrations", to: "events/registrations#index", as: :registrations_for
      get "register", to: "events/registrations#new", as: :register_to
      post "register", to: "events/registrations#create", as: :create_register_to

      # Use it for revoke user registration of any type
      get "leave", to: "events/participations#leave"

      # Calendars integration
      post "add_to_google_calendar", to: "events/integrations#add_to_google_calendar"
      get "download_ics_file", to: "events/integrations#download_ics_file"

      put "publish"
    end
  end

  resources :users do
    collection do
      get "/active", to: "users#active"
      get "/recent", to: "users#recent"
    end
    resource :avatars, only: [:create, :destroy], controller: "users/avatars"
  end

  resources :photos, only: [:index]

  resources :places, only: [:index] do
    get "/find", to: "places#find", on: :collection
  end

  namespace "admin" do
    get "/", to: "users#index"
    resources :users, controller: "users"
    resources :places, controller: "places"
    resources :events, controller: "events"
  end
end
