Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  devise_scope :user do
    get "sign/out" => "devise/sessions#destroy"
  end

  get "sign/in" => "account#sign_in"
  get "sign/up/complete" => "account#sign_up_complete"
  get "profile" => "account#profile"

  resources :users, :companies

  resources :events do
    member do
      post 'participate' # use it for opened-registration events
      get 'registration' # use it for closed-registration events
      put 'publish'
      put 'unpublish'
    end
    resources :entry_forms
  end
end
