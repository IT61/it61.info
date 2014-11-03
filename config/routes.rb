Rails.application.routes.draw do
  # Вход и регистрация
  resource :user_registration, only: [:new, :create]
  resource :user_session, only: [:new, :create, :destroy]

  get 'oauth/callback' => 'oauths#callback'
  get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider

  # Список пользователей, публичные профили и редактирование профилей
  resources :user_profiles, path: 'users', only: [:index, :show, :edit, :update, :destroy]

  # События
  resources :events do
    patch :publish, on: :member
    patch :cancel_publication, on: :member
  end

  resources :companies, except: [:destroy] do
    patch :publish, on: :member
    patch :cancel_publication, on: :member
  end

  post '/participate_in_event' => 'event_participations#create'
  delete '/cancel_participation' => 'event_participations#destroy'

  post '/membership_in_company' => 'company_members#create'
  delete '/cancel_membership' => 'company_members#destroy'

  root to: redirect('/events')

  get ':id' => 'high_voltage/pages#show', as: :page
end
