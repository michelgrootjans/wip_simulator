class LimitWIPForTheWholeProject
  def initialize(overall_wip_limit)
    @overall_wip_limit = overall_wip_limit
  end

  def choose_story_for(member, board)
    return if member.busy?
    return if board.stories_in_progress.count >= @overall_wip_limit && board.increases_wip?(member.skill)

    story = board.pull_story_for(member.skill)
    member.take(story)
  end

  def to_s
    "Project WIP limited to #{@overall_wip_limit}"
  end
end
