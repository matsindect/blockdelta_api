Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      #Users resource
        post   '/users/signup'   => 'users#create'
        post   '/users/login'    => 'users#login'
        get    '/users'          => 'users#index'
        get    '/users/current'  => 'users#current'
        patch  '/user/:id'       => 'users#update'
        delete '/user/:id'       => 'users#destroy'

      #blogs resource
      
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
