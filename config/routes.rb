Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  root 'sessions#new'
  resources :blogs do
    resources :comments
  end
  resources :users, only: [:new, :create, :show, :index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
