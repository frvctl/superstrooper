class Participant
  include MongoMapper::Document

  key :name, String
  key :email, String
  key :age, Integer

end
