Scheduling::Application.routes.draw do
	resources :users do
		member do
			get :google
		end
	end
	
	resources :sessions, only: [:new, :create, :destroy]

  get '/signin',  to: 'sessions#new'
  get '/signout', to: 'sessions#destroy', via: :delete
	
	resources :schedules do
		collection do
			get :calendar
			get :addnew
		end
		member do
			get :rewrite
		end
	end
  resources :projects do
		collection do
			get :autocomplete
		end
	end
	root to: "static_pages#home"
end
