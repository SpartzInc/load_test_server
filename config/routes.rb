Rails.application.routes.draw do
  resources :custom_hosts, except: [:show]

  resources :test_results
  resources :load_tests
  resources :user_scenarios
  resources :aws_accounts
  resources :users
  devise_for :users, :skip => [:registrations, :sessions]

  resources :test_schedules do
    get 'cancel'
  end

  as :user do
    get "/login" => "devise/sessions#new", :as => :new_user_session
    post "/login" => "devise/sessions#create", :as => :user_session
    delete "/logout" => "devise/sessions#destroy", :as => :destroy_user_session
  end

  root "welcome#index"
end
