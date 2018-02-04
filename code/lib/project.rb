class Project
  attr_accessor :backlog, :team

  def finished?
    backlog == done
  end

  def tick(repeat = 1)
    repeat.times do
      @team.each do |developer|
        developer.take(todo.first) unless developer.busy?
        developer.work
      end
    end
  end

  def wip
    backlog.select(&:in_progress?)
  end

  def todo
    backlog.select(&:todo?)
  end
  
  def done
    backlog.select(&:done?)
  end

  def not_done
    backlog - done
  end
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :project do
    backlog { build_list(:story, 3) }
    team { build_list(:developer, 3) }
  end
end