Rails.application.routes.draw do
  resources :events do
    resources :registrations
    resources :visits
    resources :participations

    member do
      # Calendars integration
      post "add_to_google_calendar", to: "events/integrations#add_to_google_calendar"
      get "download_ics_file", to: "events/integrations#download_ics_file"

      put "publish"
    end
  end
end
