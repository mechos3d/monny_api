# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resource :presentation, only: [:show]
  resources :syncs, only: %i[index create]

  namespace 'v2' do
    resources :syncs, only: %i[index create]
  end
end
