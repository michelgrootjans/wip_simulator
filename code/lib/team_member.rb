class TeamMember
  attr_accessor :name
  
  def to_s
    name
  end

end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :team_member do
    name { Faker::Name.name }
  end

end