Rails.application.routes.draw do
  namespace :users do
    get 'user_profiles/last_step_register'
  end

  devise_for :users, controllers: {:omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    get "signin" => "users/omniauth_callbacks#signin"
    delete "/users/sign_out" => "devise/sessions#destroy"
  end

  root 'application#welcome'

  resources :company
end
