Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "users#transactions"
  resources :users, only: [:create]
  patch '/user', to: 'users#update'
  get '/change_email', to: 'users#change_email'
  get '/user', to: 'users#show'
  get '/signup', to: 'users#new'
  get '/login', to: 'users#login'

  resources :sessions, only: [:destroy]
  match 'sessions', to: 'sessions#create', via: :get
  delete '/sessions', to: 'sessions#destroy'

  post '/transactions_csv', to: 'users#transactions_csv'
  get '/transactions_json', to: 'users#transactions_json'

  post '/authenticate', to: 'authentication#create'
end
