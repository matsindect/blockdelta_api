Rails.application.routes.draw do

  post   '/users/signup'   => 'users#create'
  post   '/users/login'    => 'users#login'
  get    '/users'          => 'users#index'
  get    '/users/current'  => 'users#current'
  patch  '/user/:id'       => 'users#update'
  delete '/user/:id'       => 'users#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
