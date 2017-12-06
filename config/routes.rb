Rails.application.routes.draw do

  root to: 'home#index'
  resources :articles
  get '/search', to: 'articles#search'
  get '/dashboard', to: 'articles#dashboard'
  get '/new_recruitment', to: 'articles#new_recruitment'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
