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
backlog = load_backlog

project = build(:project, process: process, team: team, planning: backlog)

day = 1
while !project.done? do
  puts "*** end of day #{day} ****"
  project.tick
  print_board(project)
  day += 1
end
