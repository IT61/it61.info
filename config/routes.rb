Rails.application.routes.draw do
  devise_for :users, controllers: {:omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    get "signin" => "users/omniauth_callbacks#signin"
    delete "/users/sign_out" => "devise/sessions#destroy"
  end

  root 'application#welcome'
  get 'user_profile' => 'application#profile'
end
