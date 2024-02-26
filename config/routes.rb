Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "photos#index"
  
  get "/users/:id" => "users#show", as: :user
  # resources :users, only: :show
 
  
  devise_for :users
  
  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos
end
