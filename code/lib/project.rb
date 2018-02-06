class Project
  attr_reader :backlog, :wip, :done
  def team=(t)
  end

  def planning=(p)
    @backlog  = p
    @wip = []
    @done = []
  end
  
  def tick
    if(@wip.empty?)
      new_story = @backlog.shift
      @wip.push(new_story) if new_story
    end

    unless @wip.empty?
      story_to_work_on = @wip.first
      story_to_work_on.do_work(:development) if story_to_work_on
    end

    @wip.select(&:done?).each do |done_story|
      @done.push(@wip.delete(done_story))
    end
  end

  def done?
    @backlog.empty? && @wip.empty?
  end
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :project do
    planning { build_list(:story, 3) }
    team { build_list(:developer, 3) }
  end
end