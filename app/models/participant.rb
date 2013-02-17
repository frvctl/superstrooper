class Participant
  include MongoMapper::Document

  key :name, String
  key :age, Integer
  key :email, String
  key :synesthesia, String
  key :perception, String
  key :blindness, String
  key :test_taken, Boolean, :default => false
end
