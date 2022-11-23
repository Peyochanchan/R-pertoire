Rails.application.routes.draw do

  devise_for :users

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
end
