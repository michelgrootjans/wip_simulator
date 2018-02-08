class KanbanBoard
  attr_reader :columns

  def initialize(process, backlog)

    backlog ||= []
    @number_of_stories = backlog.count
    @process = string_to_sym(process)
    @columns = {}
    @process.each do |work_type, queues|
      @columns[queues[:from]] = []
      @columns[work_type] = []
      @columns[queues[:to]] = []
    end

    first_column_name = @process.first.last[:from]
    @columns[first_column_name] = backlog.dup

    last_column_name = @process.to_a.last.last[:to]
    @last_column = @columns[last_column_name]
  end

  def string_to_sym(process)
    result = {}
    process.each do |work_column, queues|
      wait_queues = queues.symbolize_keys
      result[work_column.to_sym] = {from: wait_queues[:from].to_sym, to: wait_queues[:to].to_sym}
    end
    result
  end

  def pull_story_for(skill)
    in_queue = in_queue_for(skill)
    work_queue = work_queue_for(skill)

    story = in_queue.shift
    work_queue.push(story) if (story)
    return story
  end

  def advance_stories
    @process.keys.each do |skill|
      finished = work_queue_for(skill).select {|s| s.done_for?(skill)}
      finished.each do |story|
        work_queue_for(skill).delete(story)
        out_queue_for(skill).push(story)
      end
    end
  end

  def column(name)
    @columns[name]
  end

  def done?
    @last_column.count == @number_of_stories
  end

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
end