Rails.application.routes.draw do
  devise_for :users
  unauthenticated :user do
    root to: 'pages#home', as: :home
  end

  authenticated do
    root to: 'lists#index', as: :user_root
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :songs
  resources :lists
  # Defines the root path route ("/")
  # root "articles#index"
end
