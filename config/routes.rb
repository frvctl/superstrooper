Superstrooper::Application.routes.draw do
	post '/test/:id/submit-data', :to => "test#record_data"
	get '/results', :to => 'test#results'
	get '/data', :to => 'test#data'

	resources :participants do
		member do
			resources :test, :only => [:index]
			get '/survey', :to => 'test#survey'
		end
	end

	root to: 'static#home'

end
