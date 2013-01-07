Scheduling::Application.routes.draw do
	resources :schedules
  resources :projects do
	collection do
			get :autocomplete
		end
	end
	root to: "static_pages#home"
end
