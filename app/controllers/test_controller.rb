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
		redirect_to survey_participant_path, :notice => "Data Submitted"
	end
end
