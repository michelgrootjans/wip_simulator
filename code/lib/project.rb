require_relative 'throw_over_the_wall'

class Project
  def team=(t)
    @team = t
  end

  def planning=(p)
    @backlog  = p
    initialize_process
  end

  def process=(p)
    @process = p
    initialize_process
  end

  def team_strategy=(strategy)
    @team_strategy = strategy
  end

  def column(name)
    @board.column(name)
  end

  def columns
    @board.columns
  end

  def tick
    @team.each do |member|
      @team_strategy.choose_story_for(member, @board)
      member.work
    end
    @board.advance_stories
  end

  def done?
    @board.done?
  end

  private

  def initialize_process
    return unless @process
    @board = KanbanBoard.new(@process, @backlog)
  end
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :project do
    planning { build_list(:story, 3) }
    team { build_list(:developer, 3) }
    process { {development: {from: :backlog, to: :done}} }
    team_strategy ThrowOverTheWall.new
  end
end