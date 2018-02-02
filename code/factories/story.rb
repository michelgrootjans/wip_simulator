require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :story do
    name { Faker::Hacker.say_something_smart }
  end

end