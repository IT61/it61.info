Rails.application.routes.draw do
  # Вход и регистрация
  resource :user_registration, only: [:new, :create]
  resource :user_session, only: [:new, :create, :destroy]

  get 'oauth/callback' => 'oauths#callback'
  get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider

  # Редактирование профиля и аккаунта
  scope :current_user, as: 'current' do
    resource :profile, controller: 'user_profiles', only: [:edit, :update]
  end

  # Список пользователей и публичные профили
  resources :user_profiles, only: [:index, :show, :edit, :destroy]

  # События
  resources :events do
    patch :publish, on: :member
    patch :cancel_publication, on: :member
  end

  post '/participate_in_event' => 'event_participations#create'
  delete '/cancel_participation' => 'event_participations#destroy'

  root to: redirect('/events')

  get ':id' => 'high_voltage/pages#show', as: :page
end
