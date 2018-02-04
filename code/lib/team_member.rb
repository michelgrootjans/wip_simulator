class TeamMember
  attr_accessor :skill

  def take(story)
    @story = story
  end

  def choose_from(backlog)
    @story = backlog.first{|story| story.ready_for?(skill)}
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
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :team_member do
    factory :developer do
      skill :development
    end
    factory :tester do
      skill :qa
    end
  end

end