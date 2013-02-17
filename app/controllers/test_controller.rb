class TestController < ApplicationController
	def index
		@nohead = true
	end

	def record_data
		@data = params[:test_data]
		redirect_to root_url
	end
end
