# frozen_string_literal: true

Rails.application.routes.draw do
  root 'terms#index'

  get '/auth/twitter/callback', to: 'sessions#create'
  post '/auth/twitter_dev/callback', to: 'sessions#create' if Rails.env.development?
  get '/auth/failure', to: 'sessions#failure'
  post '/logout', to: 'sessions#destroy'

  resources :terms, only: [], path: '', param: :year, constraints: { year: /\d+/ } do
    resources :kadais, only: %i[index show], path: '', param: :round, constraints: { round: /\d+/ } do
      resources :kougais, only: %i[index new create]

      resources :jissakus, only: %i[index new create]

      resources :links, only: %i[create destroy], shallow: true
    end

    resources :students, only: %i[index show], shallow: true

    resources :scores, only: :index
  end

  resources :works, only: [] do
    resource :vote, only: %i[create destroy]
  end

  resources :ebooks, only: %i[index create]

  resource :profile, only: %i[show update]

  resource :preference, only: %i[show update]

  resources :kadais, only: :show # For backward compatibility

  namespace :admin do
    root 'home#show'

    resources :jobs, only: :create

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

  direct :twitter_search do |options|
    "https://twitter.com/search?#{options.compact.to_param}"
  end

  direct :twitter_tweet do |options|
    "https://twitter.com/intent/tweet?#{options.compact.to_param}"
  end
end
