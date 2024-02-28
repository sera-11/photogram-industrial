Rails.application.routes.draw do
  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "photos#index"

  get ":username/liked" => "users#liked", as: :liked


  # get "/users/:id" => "users#show", as: :user
  # resources :users, only: :show
  get "/:username" => "users#show", as: :user

  get ":username/feed" => "users#feed", as: :feed

  
  # get ":username/followers"
  # get ":username/following"
end
