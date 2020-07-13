# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#show'

  get '/auth/twitter/callback', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'

  resources :kadais
end
