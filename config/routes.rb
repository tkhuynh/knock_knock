Rails.application.routes.draw do

	root 'tas#index'

  resources :users
  resources :meetings, except: :index
  resources :tas, only: [:index, :show, :edit, :update, :destroy] do 
    resources :meetings, only: :index
  end
  resources :students, only: [:show, :edit, :update, :destroy]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
end
