Rails.application.routes.draw do

  get 'sessions/new'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  } do
    # get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  unauthenticated :user do
    root to: 'pages#home', as: :home
  end

  authenticated do
    root to: 'lists#index', as: :user_root
  end

  resources :songs
  resources :lists do
    resources :list_songs, except: %i[index show] do
      collection do
        delete 'destroy_multiple'
      end
      member do
        patch :move
      end
    end
  end

  get '/poldeconf', to: 'pages#poldeconf'
  get '/cgu', to: 'pages#cgu'
end
