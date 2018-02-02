class TeamMember
  attr_accessor :name, :role


  def to_s
    "#{name} - #{role}"
  end

end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :team_member do
    name { Faker::Name.name }
  end

end