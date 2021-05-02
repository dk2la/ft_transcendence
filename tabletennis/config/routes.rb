Rails.application.routes.draw do
  root 'start_page#index'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
  end
  
  get 'users/sign_up', as: 'registration'
  get '/users/sign_in', as: 'login'
  
  get 'profiles/:id/edit', to: 'profiles#edit', as: 'edit_profile'
  patch 'profiles/:id', to: 'profiles#update', as: 'update_profile'
  post  'profiles/invite_friend', to: 'profiles#invite_friend', as: 'invite'
  resources :profiles
  
  get '/guilds/leave_from_guild/:id', to: 'guilds#leave_from_guild', as: 'leave_from_guild'
  get '/guilds/accept_to_guild', to: 'guilds#accept_to_guild', as: 'accept'
  get '/guilds/set_officer', to: 'guilds#set_officer', as: 'set_officer'
  resources :guilds

  resources :list_players

  get 'friendship/update'
  get 'friendship/create'
  get 'friendship/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
