# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resources :syncs, only: %i[index create]

  resource :presentation, only: [:show]
end
