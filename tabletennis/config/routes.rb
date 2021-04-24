Rails.application.routes.draw do
  root 'start_page#index'
  get '/home/index', as: 'start_page_root'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
  end
  
  get 'users/sign_up', as: 'registration'
  get 'home/index', as: 'home'
  get 'guilds/index', as: 'guild'
  get '/users/sign_in', as: 'login'
  
  resources :guilds
  get '/guilds/new', to: 'guilds#new', as: "new_guildd"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
