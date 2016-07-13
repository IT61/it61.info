Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  devise_scope :user do
    get "sign/out" => "devise/sessions#destroy"
  end

  get "sign/in" => "account#sign_in"
  get "sign/up/complete" => "account#sign_up_complete"
  get "profile" => "account#profile"
  get "/events/places" => "events#places"
  post "/users/:id/update_avatar" => "users#update_avatar"
  get "/users/:id/delete_avatar" => "users#destroy_avatar"

  resources :users, :events, :companies
end
