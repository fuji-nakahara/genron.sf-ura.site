# frozen_string_literal: true

Rails.application.routes.draw do
  constraints host: 'genron-sf-fun.herokuapp.com' do
    get '/(*path)', to: redirect { |params,| "https://genron.sf-ura.site/#{params[:path]}" }
  end

  root 'terms#index'

  get '/auth/twitter/callback', to: 'sessions#create'
  get '/auth/twitter2/callback', to: 'sessions#create'
  post '/auth/twitter_dev/callback', to: 'sessions#create' if Rails.env.development?
  get '/auth/failure', to: 'sessions#failure'
  post '/logout', to: 'sessions#destroy'

  resources :terms, only: [], path: '', param: :year, constraints: { year: /\d+/ } do
    resources :kadais, only: %i[index show], path: '', param: :round, constraints: { round: /\d+/ } do
      resources :kougais, only: %i[index new create]

      resources :jissakus, only: %i[index new create]

      resources :links, only: %i[create destroy], shallow: true
    end

    resources :students, only: %i[index show], shallow: true do
      scope module: :students do
        resources :kougais, only: :index

        resources :jissakus, only: :index
      end
    end

    resources :scores, only: :index, defaults: { format: 'json' }
  end

  resources :works, only: [] do
    resource :vote, only: %i[create destroy]
  end

  resources :ebooks, only: %i[index create]

  resource :profile, only: %i[show update]

  resource :preference, only: :update

  resources :kadais, only: :show # For backward compatibility

  namespace :admin do
    root 'home#show'

    resources :jobs, only: :create

    resources :prizes, only: :create

    resources :student_merge_candidates, only: :destroy

    resources :students, only: [] do
      collection do
        post :merge
      end
    end

    resources :users, only: :index
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
end
