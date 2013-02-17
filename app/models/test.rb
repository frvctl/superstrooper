class Test
  include MongoMapper::Document

  key :display_word, 	String
  key :text_color, 	String
  key :response_time, 	Integer
  key :question_num, 	Integer
  key :attempts, 	Integer

end
