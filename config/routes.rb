
MoVember::Application.routes.draw do

  root :to => 'public#index'
  
  match 'info', :to => "public#info", :via => :get
  match 'login', :to => 'auth#login_form', :via => :get
  match 'authenticate', :to => "auth#authenticate", :via => [:get, :post], as: "authenticate"
  match 'logout', :to => 'auth#logout', :via => :get
  match 'me.json', :to => "users#me", :via => :get
  
  match 'results', :via => :get, :to => 'public#results'

  resources :features, :except => [:show]
  resources :people, :except => [:show]
  resources :votes, :except => [:show, :edit, :update, :destroy] do
    collection do
      get :personal
      delete :destroy
    end
  end
  resources :users
  
end
