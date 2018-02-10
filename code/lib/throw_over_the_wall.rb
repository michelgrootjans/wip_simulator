class ThrowOverTheWall
  def choose_story_for(member, board)
    return if member.busy?

    story = board.pull_story_for(member.skill)
    member.take(story)
  end

  def to_s
    "Take work and throw it over the wall"
  end
end

require_relative 'limit_wip_for_the_whole_project.rb'
