resources :events do
  scope module: :events do
    resources :postreleases do
      resources :materials
      put :publish, on: :member
      put :unpublish, on: :member
    end
    resources :registrations
    resources :visits
    resources :participations, only: [:create, :destroy, :index]
  end

  collection do
    get :past
    get :unpublished
    get :upcoming
  end

  member do
    get :ics
    put :publish
    put :unpublish
    get :leave
    get :participate
  end
end
