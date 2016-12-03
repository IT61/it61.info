Rails.application.routes.draw do
  resources :events do
    resources :registrations
    resources :visits
    resources :participations

    resource :calendar

    collection do
      get "upcoming"
      get "past"
    end
  end
end
