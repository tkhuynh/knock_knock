Rails.application.routes.draw do

  resources :users
  resources :meetings, except: :edit
  resources :tas, only: [:index, :show]
  resources :students, only: :show

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
end
