resources :events do
  scope module: :events do
    resources :attendees, only: [:create, :destroy, :index]
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
  end
end
