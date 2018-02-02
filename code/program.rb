Dir["models/*.rb"].each {|file| require_relative file }
Dir["factories/*.rb"].each {|file| require_relative file }
include FactoryBot::Syntax::Methods

puts build(:story)
puts build(:story)
puts build(:story)