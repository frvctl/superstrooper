Superstrooper::Application.routes.draw do
	post '/test/submit-data', :to => "test#record_data"

	resources :participants do
		member do
			resources :test, :only => [:index]
		end
	end

	root to: 'static#home'

end
