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

  # Interface for marking participants as visited
  get "visits/:hash" => "registrations#visits", as: :event_visits
  put "visits/:hash/mark" => "registrations#mark_visit"

  resources :events do
    collection do
      get "/upcoming" => "events#upcoming"
      get "/past" => "events#past"
      get "/unpublished" => "events#unpublished"
    end

    member do
      # Use it for registration to opened events:
      get "participate" => "events#participate"

      # Use it for registration to closed events:
      get "registrations" => "registrations#index", as: "registrations_for"
      get "register" => "registrations#new", as: "register_to"
      post "register" => "registrations#create", as: "create_register_to"

      # Use it for revoke user registration of any type
      get "leave", to: "events#leave"

      # Calendars integration
      post "add_to_google_calendar"
      get "download_ics_file"

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
