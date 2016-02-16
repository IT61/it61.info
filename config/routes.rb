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
    resource :google_calendar_integrations, controller: 'events/google_calendar_integrations', only: [:create, :destroy]
  end

  resources :companies, except: [:destroy] do
    patch :publish, on: :member
    patch :cancel_publication, on: :member
    scope module: :companies do
      resources :membership_requests, only: [:index, :create] do
        patch :approve, on: :member
        patch :hide, on: :member
      end
    end

  end

  # Admin routes
  namespace :admin do
    resources :companies, only: [] do
      scope module: :companies do
        resources :members, only: [:index, :update], shallow: true
      end
    end
  end

  post '/participate_in_event' => 'event_participations#create'
  delete '/cancel_participation' => 'event_participations#destroy'

  delete '/cancel_membership' => 'companies/members#destroy'

  root to: redirect('/events')

  get ':id' => 'high_voltage/pages#show', as: :page
end
