class Project
  attr_accessor :backlog, :team

  def finished?
    backlog == done
  end

  def tick(repeat = 1)
    repeat.times do
      @team.each do |developer|
        not_done.first.do_work if not_done.any?
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

class Story
  attr_accessor :duration

  def initialize
    @duration = 1
    @work = 0
  end

  def do_work
    @work += 1
  end

  def done?
    @duration <= @work
  end

  def todo?
    @work == 0
  end

  def in_progress?
    @work > 0 && !done?
  end
end

class Developer
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :project do
    backlog { build_list(:story, 3) }
    team { build_list(:developer, 3) }
  end

  factory :story do
  end

  factory :developer do
  end

end