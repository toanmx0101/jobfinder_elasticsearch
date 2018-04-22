Rails.application.routes.draw do

  resources :applies
  resources :messages
  get 'notifications/index'

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }  
  devise_scope :user do
    get 'login', to: 'users/sessions#new' 
	  get 'join', to: 'users/registrations#new'
    get '/join/plan', to: 'users/registrations#plan'
    get '/join/finish', to: 'users/registrations#first_signup_fill_infor'
    put '/user_update', to: 'users/registrations#update'
    # as :user do
    #   get 'users/profile', :to => 'devise/registrations#edit', :as => :user_root
    # end
	end
  root to: 'home#index'
  resources :jobs

  resources :home do
  end
  get '/job/#{slug}-#{id}', to: 'jobs#edit'
  get '/jf/:id', to: 'home#profile', as: :jf
  get '/search', to: 'jobs#search'
  get '/dashboard', to: 'jobs#dashboard'
  get '/new_recruitment', to: 'jobs#new'
  get '/join/details_infor', to: 'user#details_infor'
  get '/messagesss', to: 'home#message_thread'
  get '/profile', to: 'home#user_profile'
  get '/setting', to: 'home#setting'
  get 'appropriate_jobs/', to: 'home#appropriate_jobs'

  resources :messages
  resources :notifications
  mount ActionCable.server => '/cable'
end
