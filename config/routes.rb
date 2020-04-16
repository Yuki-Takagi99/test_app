Rails.application.routes.draw do
  root 'sessions#new'
  resources :blogs do
    resources :comments
  end
  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
end
