Scheduling::Application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
	resources :users do
		member do
			get :google
		end
	end
	
	resources :sessions, only: [:new, :create, :destroy]
	resources :features do
	  member do 
	    get :toggle
	  end
	end
	get '/signin',  to: 'sessions#new'
  get '/signout', to: 'sessions#destroy', via: :delete
	
	resources :schedules do
		collection do
			get :calendar
			get :addnew
		end
		member do
			get :rewrite
			get :calendar_update
			get :pop_up
		end
	end
  resources :projects do
		collection do
			get :autocomplete
		end
	end
	resources :static_pages do
		member do
			get :rewrite
		end
	end
	root to: "static_pages#home"
end
