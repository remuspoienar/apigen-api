Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :api_projects, only: [:index, :create, :show, :update, :destroy] do
        get :launch, on: :member
        get :shutdown, on: :member
        get :permissions, on: :member
      end

      resources :trait_options, only: [:index]
      resources :db_type_options, only: [:index]

      # get '' => 'api_projects#index'
      # get '' => 'api_projects#show'
      # get '' => 'api_projects#create'
      # get '' => 'api_projects#update'
      # get '' => 'api_projects#destroy'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/sign_in' => 'sessions#create'
  get '/sign_out' => 'sessions#destroy'

  get '/api_users' => 'users#index'
  post '/sign_up' => 'users#create'
  get '/me' => 'users#me'

end
