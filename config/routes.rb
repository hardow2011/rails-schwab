Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "users#transactions"
  resources :users, only: [:create]
  patch '/user', to: 'users#update'
  get '/request_email_change', to: 'users#request_email_change'
  get '/user', to: 'users#show'
  patch '/update_email', to: 'users#update_email'
  get '/signup', to: 'users#new'
  get '/login', to: 'users#login'

  resources :sessions, only: [:destroy]
  match 'sessions', to: 'sessions#create', via: :get
  delete '/sessions', to: 'sessions#destroy'
  get '/change_email', to: 'sessions#change_email'

  post '/transactions_csv', to: 'users#transactions_csv'
  get '/transactions_json', to: 'users#transactions_json'

  post '/authenticate', to: 'authentication#create'
end
