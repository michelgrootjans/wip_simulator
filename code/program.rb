Dir["models/*.rb"].each {|file| require_relative file }
Dir["factories/*.rb"].each {|file| require_relative file }
include FactoryBot::Syntax::Methods

build_list(:story, 10).each do |story|
  puts story
end
