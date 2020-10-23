# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#show'

  get '/auth/twitter/callback', to: 'sessions#create'
  post '/auth/twitter_dev/callback', to: 'sessions#create' if Rails.env.development?
  get '/auth/failure', to: 'sessions#failure'
  post '/logout', to: 'sessions#destroy'

  resources :kadais, only: :show do
    collection do
      get '/find/:year/:number', action: :find
    end

    resources :kougais, only: %i[new create]

    resources :jissakus, only: %i[new create]

    resources :links, only: %i[create destroy], shallow: true
  end

  resources :students, only: :show do
    collection do
      get '/find/:genron_sf_id', action: :find
    end
  end

  resources :works, only: [] do
    resource :vote, only: %i[create destroy]
  end

  resources :scores, only: :show, param: :year

  resources :ebooks, only: %i[index create]

  resource :profile, only: %i[show update]

  namespace :admin do
    root 'home#show'

    resources :elections, only: :create

    resources :prizes, only: :create

    resources :students, only: [] do
      collection do
        post :merge
      end
    end
  end

  direct :genron_sf do
    'https://school.genron.co.jp/sf/'
  end

  direct :github_repo do
    'https://github.com/fuji-nakahara/genron-sf-fun'
  end

  direct :twitter_profile do |screen_name|
    "https://twitter.com/#{screen_name}"
  end

  direct :twitter_tweet do |options|
    "https://twitter.com/intent/tweet?#{options.compact.to_param}"
  end
end
