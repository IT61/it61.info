Rails.application.routes.draw do
  resources :events do
    resources :registrations
    resources :visits
    resources :participations

    resource :calendar
  end
end
