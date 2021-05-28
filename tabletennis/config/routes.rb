Rails.application.routes.draw do
  get 'errors/show'
  mount ActionCable.server => '/cable'
  get 'abouts/index'
  root 'start_page#index'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
  end
  
  get 'users/sign_up', as: 'registration'
  get '/users/sign_in', as: 'login'
  
  get 'profiles/rating_shop', to: 'profiles#rating_shop', as: 'rating_shop'
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
  
  get '/games/create_war_time', to: 'games#create_war_time', as: 'create_war_time'
  get '/games/create_ladder', to: 'games#create_ladder', as: 'create_ladder'
  get '/games/leave_from_game', to: "games#leave_from_game", as: 'leave_from_game'
  get '/games/join_to_game', to: "games#join_to_game", as: 'join_game'
  resources :games

  post '/chat_rooms/verificate_password', to: 'chat_rooms#verificate_password', as: 'verificate_password'
  get '/chat_rooms/remove_password', to: 'chat_rooms#remove_password', as: 'remove_password'
  get '/chat_rooms/create_dm', to: 'chat_rooms#create_dm', as: 'create_dm'
  get '/chat_rooms/unblock_user', to: 'chat_rooms#unblock_user', as: 'unblock_user'
  get '/chat_rooms/block_user', to: 'chat_rooms#block_user', as: 'block_user'
  get '/chat_rooms/umute_member', to: 'chat_rooms#umute_member', as: 'umute_member'
  get '/chat_rooms/mute_member', to: 'chat_rooms#mute_member', as: 'mute_member'
  get '/chat_rooms/ban_user', to: 'chat_rooms#ban_user', as: 'ban_user'
  get '/chat_rooms/unban_user', to: 'chat_rooms#unban_user', as: 'unban_user'
  get '/chat_rooms/remove_moderator', to: 'chat_rooms#remove_moderator', as: 'remove_moderator'
  get '/chat_rooms/set_moderator', to: 'chat_rooms#set_moderator', as: 'set_moderator'
  get '/chat_rooms/leave_from_room', to: 'chat_rooms#leave_from_room', as: 'leave_from_chat'
  get '/chat_rooms/join_chat_room', to: 'chat_rooms#join_chat_room', as: 'join_chat'
  resources :chat_rooms
  
  resources :messages

  get 'duels/update'
  get 'duels/create'
  get 'duels/destroy'

  get 'friendship/update'
  get 'friendship/create'
  get 'friendship/destroy'

    # GUILD WARS ROUTES
    get 'guild_war/update'
    get 'guild_war/destroy'
    get '/guilds_wars/create', to: 'guild_war#create', as: 'create_war'
    post '/guilds_wars/create', to: 'guild_war#create', as: 'create_wars'
    get '/guilds_wars/update', to: 'guild_war#update', as: 'update_war'
    get '/guilds_wars/destroy', to: 'guild_war#destroy', as: 'destroy_war'
    get '/guilds_wars/show', to: 'guild_war#show', as: 'show_war'
    get '/guild_wars/configure', to: 'guild_war#configure', as: "configure_war"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
