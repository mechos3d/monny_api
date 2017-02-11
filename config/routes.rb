Rails.application.routes.draw do
  resources :syncs, only: [:index, :create]

  resource :presentation, only: [:show]
end
