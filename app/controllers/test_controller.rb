class TestController < ApplicationController
	def index
		@nohead = true
	end

	def survey
		@participant = Participant.find(params[:id])
	end

	def results
		@participant = Participant.find(params[:id])
	end

	def result
		@participant = Participant.find(params[:id])
	end

	def data
		render :json => Participant.all
	end

	def single_data
		@participant = Participant.find(params[:id])
		render :json => [@participant]
	end

	def record_data
		@participant = Participant.find(params[:id])
		@data = ActiveSupport::JSON.decode(params[:test_data])
		Participant.record_data(@participant, @data)
		redirect_to survey_participant_path, :notice => "Test Completed! Your data has been submitted."
	end
end
