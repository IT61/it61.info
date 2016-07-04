Rails.application.routes.draw do
  devise_for :users, controllers: {:omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    delete "/users/sign_out" => "devise/sessions#destroy"
  end

  root 'application#welcome'
end
