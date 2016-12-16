resources :events do
  scope module: :events do
    resources :registrations
    resources :visits
    resources :participations, only: [:create, :destroy]
  end

  collection do
    get :upcoming
    get :past
  end

  member do
    get :ics
  end
end
