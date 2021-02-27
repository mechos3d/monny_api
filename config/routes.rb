# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resource :presentation, only: [:show]
  namespace 'v2' do

    # NOTE: for backup:
    # curl --header 'Authorization: Bearer <token>' 'https://<host>/v2/syncs?backup=true'
    resources :syncs, only: %i[index create]
  end
end
