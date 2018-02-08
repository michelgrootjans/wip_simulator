class ThrowOverTheWall
  def choose_story_for(member, board)
    return if member.busy?

    story = board.pull_story_for(member.skill)
    member.take(story)
  end
end
