require 'json'
Dir["lib/*.rb"].each {|file| require_relative file }
include FactoryBot::Syntax::Methods

def load_process
  JSON.parse(File.read('data/process.json'))
end

def load_team
  team_hash = JSON.parse(File.read('data/team.json'))
  team_hash.map {|member_hash| build(:team_member, name: member_hash['name'], skill: member_hash['skill'])}
end

def load_backlog
  backlog_hash = JSON.parse(File.read('data/backlog.json'))
  backlog_hash.map {|member_hash| build(:story, name: member_hash['name'], expected_work: member_hash['expected_work'])}
end

def print_board(project)
  puts "*******************************************"
  project.columns.each do |column|
    puts "************"
    puts column.first
    puts "------------"
    puts column.last.map(&:name)
  end
end

process = load_process
team = load_team
backlog = load_backlog

project = build(:project, process: process, team: team, planning: backlog)

print_board(project)
project.tick
print_board(project)

