class TeamMember
  attr_accessor :skill

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
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :team_member do
    factory :developer do
      skill :development
    end
  end

end