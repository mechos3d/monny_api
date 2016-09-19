Rails.application.routes.draw do
  root 'welcome#index'

  get '/topics/:id', to: 'welcome#show'
  post '/topics', to: 'welcome#create'

end
