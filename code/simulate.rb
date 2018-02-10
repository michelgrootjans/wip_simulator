require 'json'
Dir["lib/*.rb"].each {|file| require_relative file }
include FactoryBot::Syntax::Methods

def load_process
  JSON.parse(File.read('data/process.json'))
end

def load_team
  team_hash = JSON.parse(File.read('data/team.json'))
  team_hash.map {|member_hash| build(:team_member, name: member_hash['name'], skill: member_hash['skill'].to_sym)}
end

def load_backlog
  backlog_hash = JSON.parse(File.read('data/backlog.json'))
  backlog_hash.map {|member_hash| build(:story, name: member_hash['name'], expected_work: member_hash['expected_work'].symbolize_keys)}
end

def print_board(project)
  project.columns.each do |column|
    puts "#{column.first}: #{column.last.count}"
  end
end

process = load_process
team = load_team

strategies = [
    ThrowOverTheWall.new,
    LimitWIPForTheWholeProject.new(1),
    LimitWIPForTheWholeProject.new(2),
    LimitWIPForTheWholeProject.new(3),
    LimitWIPForTheWholeProject.new(4),
    LimitWIPForTheWholeProject.new(5),
    LimitWIPForTheWholeProject.new(6),
]

strategies.each do |strategy|
  backlog = load_backlog
  project = build(:project, process: process, team: team, planning: backlog.dup, team_strategy: strategy)
  project.tick while !project.done?
  puts "*** strategy: #{project.team_strategy} ***"
  puts "throughput: #{"%.2g" % project.throughput} stories/tick"
  puts "lead time per story: #{"%.2g" % project.lead_time} ticks"
  puts
end
