Rails.application.routes.draw do
  root "home#index"
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    post 'users/guest_sign_in', to:'users/sessions#guest_sign_in'
    get 'users/show', to:'users/registrations#show'
  end
  resources :users, only: [] do
    resource :relationships, only: [:create, :destroy]
  end
  resources :profiles, only: [:show, :edit, :update] do
    member do
      get "show_likes"
      get "show_bookmarks"
      get "followers"
      get "following"
    end
  end
  resources :posts, except: [:index] do
    resources :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
    resource :bookmarks, only: [:create, :destroy]
    collection do
      get "search"
    end
  end
  resources :contacts, only: [:new, :create]
end
