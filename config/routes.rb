Rails.application.routes.draw do
  resources :users, only: [] do
    resources :relationships, only: [:create, :destroy]
  end
  resources :profiles, only: [:show, :edit, :update]
  root "home#index"
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :bookmarks, only: [:create, :destroy]
    collection do
      get "search"
      get "fresh"
    end
  end
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "users/show"
end
