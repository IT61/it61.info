resources :events do
  scope module: :events do
    resources :registrations
    resources :visits
    resources :participations, only: [:create, :destroy, :index]
  end

  collection do
    get :upcoming
    get :past
    get :unpublished
  end

  member do
    get :ics
    post :publish
    get :leave
    get :participate
  end
end
