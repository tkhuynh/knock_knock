Rails.application.routes.draw do

	root 'users#new'

  resources :users
  resources :meetings, except: :edit

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
end
