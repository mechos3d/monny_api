# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resource :presentation, only: [:show]
  namespace 'v2' do
    resources :syncs, only: %i[index create]
    resources :st_records, only: %i[index show create]
  end
end
