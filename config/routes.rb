Rails.application.routes.draw do

  root to: 'users#new'

  resources :users, except: :new
  resources :meetings, except: [:index, :show]
  resources :tas, only: [:index, :show]
  resources :students, only: [:show]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
end
