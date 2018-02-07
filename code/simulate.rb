Dir["lib/*.rb"].each {|file| require_relative file }
include FactoryBot::Syntax::Methods

backlog = build_list(:story, 10)
team = build_list(:developer, 3) + build_list(:tester, 1)

backlog.each{|story| puts story.inspect}
team.each{|member| puts member.inspect}