Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }  
  devise_scope :user do
    get 'login', to: 'users/sessions#new' 
	  get 'join', to: 'users/registrations#new'
    get '/join/plan', to: 'users/registrations#plan'

	end
  root to: 'home#index'
  resources :articles

  get '/search', to: 'articles#search'
  get '/dashboard', to: 'articles#dashboard'
  get '/new_recruitment', to: 'articles#new_recruitment'
  get '/join/details_infor', to: 'user#details_infor'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
