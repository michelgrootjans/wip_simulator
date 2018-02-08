require 'json'
Dir["lib/*.rb"].each {|file| require_relative file }
include FactoryBot::Syntax::Methods

development_distribution = [1, 1, 2, 2, 2, 3, 3, 3, 5, 5, 8]
qa_distribution = [1, 1, 1, 2, 2, 2, 3, 3, 3]

backlog = (1..100).map{ build(:story, expected_work: { development: development_distribution.sample, qa: qa_distribution.sample }) }
team = build_list(:developer, 3) + build_list(:tester, 1)
process = {development: {from: :backlog, to: :ready_for_qa}, qa: {from: :ready_for_qa, to: :done}}

Dir.mkdir('data') unless Dir.exist?('data')

File.open("data/backlog.json","w") do |f|
  f.write(JSON.pretty_generate(backlog.map(&:to_json)))
end
File.open("data/team.json","w") do |f|
  f.write(JSON.pretty_generate(team.map(&:to_json)))
end
File.open("data/process.json","w") do |f|
  f.write(JSON.pretty_generate(process))
end
