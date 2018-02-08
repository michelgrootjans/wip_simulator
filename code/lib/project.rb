class Project
  attr_reader :columns

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

  def column(name)
    @columns[name]
  end
  
  def tick
    @team.each do |member|
      unless member.busy?
        in_queue = in_queue_for(member.skill)
        work_queue = work_queue_for(member.skill)

        story = in_queue.shift
        if(story)
          work_queue.push(story)
          member.take(story)
        end
      end
      member.work
    end
    @process.keys.each do |skill|
      finished = work_queue_for(skill).select{|s| s.done_for?(skill)}
      finished.each do |story|
        work_queue_for(skill).delete(story)
         out_queue_for(skill).push(story)
      end
    end
  end

  def done?
    @last_column.count == @backlog.count
  end


  private
  def work_queue_for(skill)
    @columns[skill]
  end

  def in_queue_for(skill)
    in_queue_name = @process[skill][:from]
    @columns[in_queue_name]
  end

  def out_queue_for(skill)
    out_queue_name = @process[skill][:to]
    @columns[out_queue_name]
  end


  def initialize_process
    @columns = {}
    return unless @process
    @process.each do |work_type, queues|
      @columns[queues[:from]] = []
      @columns[work_type] = []
      @columns[queues[:to]] = []
    end

    backlog = @process.first.last[:from]
    @columns[backlog] = @backlog.dup

    done = @process.to_a.last.last[:to]
    @last_column = @columns[done]
  end
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :project do
    planning { build_list(:story, 3) }
    team { build_list(:developer, 3) }
    process { {development: {from: :backlog, to: :done}} }
  end
end