# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#show'

  get '/auth/twitter/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  post '/logout', to: 'sessions#destroy'

  resources :kadais, only: :show do
    collection do
      get '/find/:year/:number', action: :find
    end
  end

  resources :students, only: :show do
    collection do
      get '/find/:genron_sf_id', action: :find
    end
  end

  direct :genron_sf do
    'https://school.genron.co.jp/sf/'
  end

  direct :twitter_profile do |screen_name|
    "https://twitter.com/#{screen_name}"
  end
end
