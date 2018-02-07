class TeamMember
  attr_accessor :skill, :name

  def take(story)
    @story = story
  end

  def work
    @story.do_work(skill) if @story
  end

  def busy?
    return false unless @story
    !@story.done_for?(skill)
  end

  def idle?
    !busy?
  end

  def to_json
    {name: name, skill: skill}
  end
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :team_member do
    name { Faker::Name.name }

    factory :developer do
      skill :development
    end
    factory :tester do
      skill :qa
    end
  end

end