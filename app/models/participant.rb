class Participant
	include MongoMapper::Document
	many :tests

	key :name, 		String
	key :age, 		Integer
	key :email, 		String
	key :synesthesia, 	String
	key :perception, 	String
	key :blindness,	 	String
	key :altered_state,	String
	key :test_taken, 	Boolean, :default => false
	key :survey_taken, 	Boolean, :default => false

	def self.record_data(participant, data)
		unless participant.test_taken
			data.map { |test_data|   aTest = Test.new(
								:display_word => test_data["word"],
								:text_color => test_data["color"],
								:response_time => test_data["elapsed"],
								:question_num => test_data["num"],
								:attempts => test_data["attempts"]
							)
					participant.tests.push(aTest)
					participant.test_taken = true
					participant.save!
				}
		end
	end
end
