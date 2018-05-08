Rails.application.routes.draw do

  resources :interviews, except: [:index, :new, :show]
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
  end
  root to: 'home#index'
  resources :jobs

  get :appliers, to: 'home#appliers'
  get :interviews, to: 'home#interviews'
  get 'interviews/new', to: 'home#new_interviews'
  get :candidates, to: 'home#candidates'
  get :rc_messages, to: 'home#rc_messages'

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
