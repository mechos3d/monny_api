Rails.application.routes.draw do
  resources :syncs, only: [:index, :create]

  # post '/syncs', to: 'syncs#create' # TODO make a resoursefull route
end
