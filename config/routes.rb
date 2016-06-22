Rails.application.routes.draw do
  resource :user_session, only: [ :new ]
  resource :user_registration, only: [ :new ]
end
