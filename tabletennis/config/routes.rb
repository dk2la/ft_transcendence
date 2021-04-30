Rails.application.routes.draw do
  root 'start_page#index'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
  end
  
  get 'users/sign_up', as: 'registration'
  get '/users/sign_in', as: 'login'
  
  resources :home
  get 'home/index', to: 'home#index'
  get 'home/:id/edit', to: 'home#edit', as: 'user'
  patch 'home/:id', to: 'home#update', as: 'update_user'
  post  'home/invite_friend', to: 'home#invite_friend', as: 'invite'
  
  get '/guilds/accept_to_guild', to: 'guilds#accept_to_guild', as: 'accept'
  resources :guilds

  resources :list_players

  get 'friendship/update'
  get 'friendship/create'
  get 'friendship/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
