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
      get "/active", to: "users#active"
      get "/recent", to: "users#recent"
    end
    resource :avatars, only: [:create, :destroy], controller: "users/avatars"
  end

  resources :photos, only: [:index]

  resources :places, only: [:index] do
    get "/find", to: "places#find", on: :collection
  end
end

[:admin, :events].each do |route_file|
  require "#{Rails.root}/config/routes/#{route_file}"
end
