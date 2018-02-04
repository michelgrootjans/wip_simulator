class Project
  def initialize(backlog, team)
    @stories = backlog
    @team = team
  end

  def finished?
    backlog.empty?
  end

  def tick(repeat = 1)
    repeat.times do
      @team.each do |developer|
        backlog.first.decrement if backlog.any?
      end
    end
  end

  def backlog
    @stories - done
  end
  
  def done
    @stories.select(&:done?)
  end
end

class Story
  attr_accessor :name

  def initialize
    @estimate = 1
  end

  def decrement
    @estimate -= 1
  end

  def done?
    @estimate <= 0
  end
end

class Developer
  attr_accessor :name
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :story do
    name { Faker::Hacker.say_something_smart }
  end

  factory :developer do
    name { Faker::Name.name }
  end

end