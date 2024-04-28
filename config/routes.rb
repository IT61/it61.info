Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth"
  }

  devise_scope :user do
    get "sign_in", to: "users/profile#sign_in", as: :new_session
    get "sign_out", to: "devise/sessions#destroy"
  end

  # Static pages
  %w[welcome about].each do |page_name|
    get page_name, to: "pages##{page_name}"
  end

  get "sign_up/complete", to: "users/profile#sign_up_complete"
  get "profile", to: "users/profile#profile"

  scope "profile" do
    get   "edit", to: "users/profile#edit", as: :edit_profile
    get   "settings", to: "users/profile#settings", as: :profile_settings
    patch "settings_update", to: "users/profile#settings_update"
  end

  resources :users do
    collection do
      get :active
      get :recent
    end
    resource :avatars, only: [ :create, :destroy ], controller: "users/avatars"
  end

  resources :events do
    scope module: :events do
      resources :attendees, only: [ :create, :destroy, :index ]
    end

    collection do
      get :past
      get :unpublished
      get :upcoming
    end

    member do
      get :ics
      put :publish
      put :unpublish
    end
  end

  resources :places, only: [ :index ] do
    get :find, to: "places#find", on: :collection
  end

  get :feed, to: "events#feed", defaults: { format: "rss" }

  namespace :admin do
    root "users#index"

    resources :users
    resources :places
    resources :events
  end

  root "pages#welcome"

  get "*any", via: :all, to: "errors#not_found"
end
