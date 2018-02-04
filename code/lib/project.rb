class Project
  def initialize(backlog)
    @stories = backlog
  end

  def finished?
    backlog.empty?
  end

  def tick(repeat = 1)
    repeat.times do
       backlog.first.decrement if backlog.any?
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

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :story do
    name { Faker::Hacker.say_something_smart }
  end

end