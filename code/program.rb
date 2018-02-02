Dir["models/*.rb"].each {|file| require_relative file }
include FactoryBot::Syntax::Methods

backlog = build_list(:story, 10)
team = build_list(:team_member, 3, role: "developer") + build_list(:team_member, 1, role: "qa")

backlog.each{|story| puts story}
team.each{|member| puts member}