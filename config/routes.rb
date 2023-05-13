Rails.application.routes.draw do
  get 'profiles/:id', to: 'profiles#show', as: 'profile'
  root "home#index"
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :posts do
    collection do
      get "search"
      get "fresh"
    end
  end
  get "users/show"
end
