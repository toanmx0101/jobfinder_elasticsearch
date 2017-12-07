Rails.application.routes.draw do

  devise_for :users
  devise_scope :user do
	  get 'login', to: 'devise/sessions#new'
	  get 'join', to: 'devise/registrations#new'
	end
  root to: 'home#index'
  resources :articles
  get '/search', to: 'articles#search'
  get '/dashboard', to: 'articles#dashboard'
  get '/new_recruitment', to: 'articles#new_recruitment'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
