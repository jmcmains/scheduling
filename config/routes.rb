Scheduling::Application.routes.draw do
	resources :schedules do
		collection do
			get :calendar
		end
	end
  resources :projects do
		collection do
			get :autocomplete
		end
	end
	root to: "static_pages#home"
end
