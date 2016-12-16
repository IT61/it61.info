Rails.application.routes.draw do
  root "pages#welcome"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth",
  }

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
    get   "settings", to: "users/profile#settings", as: :profile_settings
    patch "settings_update", to: "users/profile#settings_update"
  end

  resources :companies

  resources :users do
    collection do
      get :active
      get :recent
    end
    resource :avatars, only: [:create, :destroy], controller: "users/avatars"
  end

  resources :photos, only: [:index]

  resources :places, only: [:index] do
    get :find, to: "places#find", on: :collection
  end

  resources :events do
    scope module: :events do
      resources :registrations
      resources :visits
      resources :participations, only: [:create, :destroy]
    end

    collection do
      get :upcoming
      get :past
    end

    member do
      get :ics
    end
  end
end

[:admin].each do |route_file|
  require_dependency "#{Rails.root}/config/routes/#{route_file}"
end
