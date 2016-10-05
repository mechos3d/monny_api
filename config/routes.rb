Rails.application.routes.draw do
  resources :syncs, only: [:index, :create]

  resource :sum, only: [:show]
  # post '/syncs', to: 'syncs#create' # TODO make a resoursefull route
end
