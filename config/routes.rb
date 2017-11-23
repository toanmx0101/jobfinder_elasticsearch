Rails.application.routes.draw do
  resources :articles do
    collection { get :search }
  end

  resources :articles do
    collection { get :search }
  end

  root to: 'articles#index'
  resources :articles do
    collection { get :search }
  end
  get '/dashboard', to: 'articles#dashboard'
  get '/new_recruitment', to: 'articles#new_recruitment'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
