Superstrooper::Application.routes.draw do

	resources :participants do
		member do
			resources :test, :only => [:index]
		end
	end

	root to: 'static#home'

end
