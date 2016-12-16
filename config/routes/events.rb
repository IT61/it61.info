Rails.application.routes.draw do
  resources :events do
    resources :registrations
    resources :visits
    resources :participations

    resource :calendar do
      get :ics, to: "calendar#ics", as: "ics_file"
    end

    collection do
      get "upcoming"
      get "past"
    end
  end
end
