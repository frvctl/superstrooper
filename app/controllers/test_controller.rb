class TestController < ApplicationController
	def index
		@nohead = true
	end

	def survey

	end

	def record_data
		@participant = Participant.find(params[:id])
		@data = ActiveSupport::JSON.decode(params[:test_data])
		Participant.record_data(@participant, @data)
	end
end
