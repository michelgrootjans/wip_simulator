require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :story do
    name { Faker::Hacker.say_something_smart }
    development { [1, 2, 2, 2, 3, 3, 3, 5, 5, 8, 13].sample }
    review { [1, 1, 1, 2, 2, 2, 3].sample }
    qa { [1, 1, 1, 2, 2, 2, 3, 3, 3, 5, 8, 13].sample }
  end

end