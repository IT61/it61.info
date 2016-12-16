resources :places, only: [:index] do
  get :find, to: "places#find", on: :collection
end
