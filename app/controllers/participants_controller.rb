class ParticipantsController < ApplicationController
	def index
		@participants = Participant.all
	end

	def show
		@participant = Participant.find(params[:id])
	end

	def new
		@participant = Participant.new
	end

	def edit
		@participant = Participant.find(params[:id])
	end

	def create
		@participant = Participant.new(params[:participant])

		respond_to do |format|
			if @participant.save
				format.html { redirect_to @participant, notice: 'Participant was successfully created.' }
				format.json { render json: @participant, status: :created, location: @participant }
			else
				format.html { render action: "new" }
				format.json { render json: @participant.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@participant = Participant.find(params[:id])

		respond_to do |format|
			if @participant.update_attributes(params[:participant])
					format.html { redirect_to @participant, notice: 'Participant was successfully updated.' }
					format.json { head :no_content }
			else
					format.html { render action: "edit" }
					format.json { render json: @participant.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@participant = Participant.find(params[:id])
		@participant.destroy
		redirect_to participants_url
	end
end
