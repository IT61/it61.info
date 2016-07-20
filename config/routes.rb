Rails.application.routes.draw do
   devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  devise_scope :user do
    get "sign/out" => "devise/sessions#destroy"
  end

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
      get "/upcoming" => "events#index", scope: :upcoming
      get "/past" => "events#index", scope: :past
    end
  end

  resources :users do
    resource :avatars, only: [:create, :destroy], controller: 'users/avatars'
  end

  resources :photos, only: [:index]
end
