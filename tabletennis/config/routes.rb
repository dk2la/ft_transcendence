Rails.application.routes.draw do
  get 'abouts/index'
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
  get '/guilds/remove_from_officer', to: 'guilds#remove_from_officer', as: 'remove_officer'
  get '/guilds/kick_member_from_guild', to: 'guilds#kick_member_from_guild', as: 'kick_member'
  resources :guilds

  resources :list_players

  resources :games

  get '/chat_rooms/mute_member', to: 'chat_rooms#mute_member', as: 'mute_member'
  get '/chat_rooms/ban_user', to: 'chat_rooms#ban_user', as: 'ban_user'
  get '/chat_rooms/unban_user', to: 'chat_rooms#unban_user', as: 'unban_user'
  get '/chat_rooms/remove_moderator', to: 'chat_rooms#remove_moderator', as: 'remove_moderator'
  get '/chat_rooms/set_moderator', to: 'chat_rooms#set_moderator', as: 'set_moderator'
  get '/chat_rooms/leave_from_room', to: 'chat_rooms#leave_from_room', as: 'leave_from_chat'
  get '/chat_rooms/join_chat_room', to: 'chat_rooms#join_chat_room', as: 'join_chat'
  resources :chat_rooms
  resources :messages
  get 'friendship/update'
  get 'friendship/create'
  get 'friendship/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
