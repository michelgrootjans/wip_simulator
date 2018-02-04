class Project
  attr_accessor :backlog, :team

  def finished?
    todo.empty?
  end

  def tick(repeat = 1)
    repeat.times do
      @team.each do |developer|
        todo.first.decrement if todo.any?
      end
    end
  end

  def todo
    backlog - done
  end
  
  def done
    backlog.select(&:done?)
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
  factory :project do
    backlog { build_list(:story, 3) }
    team { build_list(:developer, 3) }
  end

  factory :story do
    name { Faker::Hacker.say_something_smart }
  end

  factory :developer do
    name { Faker::Name.name }
  end

end