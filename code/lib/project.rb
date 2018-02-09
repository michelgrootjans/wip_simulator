require_relative 'throw_over_the_wall'

class Project

  def initialize
    @days = 0
  end

  def team=(t)
    @team = t
  end

  # expressed in number of stories/tick
  def throughput
    return 0 if @days == 0
    1.0 * @board.done.count / @days
  end

  # expressed in number of ticks
  def lead_time
    return "n/a" if @board.done.count == 0
    1.0 * @board.done.map(&:lead_time).reduce(&:+) / @board.done.count
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
    @days += 1
    @team.each do |member|
      @team_strategy.choose_story_for(member, @board)
      member.work
    end
    @board.tick
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