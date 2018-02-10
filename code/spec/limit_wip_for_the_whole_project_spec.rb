describe "Limit WIP to 1 for the whole project" do
  context "with only development work" do
    subject(:project) { build(:project, team: team, planning: planning, process: process, team_strategy: strategy) }
    let(:process) { {development: {from: :backlog, to: :done}} }
    let(:strategy) { LimitWIPForTheWholeProject.new(1) }

    context "with one developer and one develpment(1) story" do
      let(:team) { [build(:developer)] }
      let(:story) { build(:story, expected_work: {development: 1})}
      let(:planning) { [story] }
      let(:process) { {development: {from: :backlog, to: :done}} }

      before { project.tick }
      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:done)).to eq [story]}
    end

    context "with two developers and two develpment(1) story" do
      let(:team) { build_list(:developer, 2) }
      let(:story_1) { build(:story, expected_work: {development: 1})}
      let(:story_2) { build(:story, expected_work: {development: 1})}
      let(:planning) { [story_1, story_2] }
      let(:process) { {development: {from: :backlog, to: :done}} }

      before { project.tick }
      it { expect(project.column(:backlog)).to eq [story_2]}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:done)).to eq [story_1]}
    end

    context "with a developer and tester and two stories(1/2)" do
      let(:team) { [build(:developer), build(:tester)] }
      let(:story_1) { build(:story, expected_work: {development: 1, qa: 2}, name: "story 1")}
      let(:story_2) { build(:story, expected_work: {development: 1, qa: 2}, name: "story 2")}
      let(:planning) { [story_1, story_2] }
      let(:process) { {development: {from: :backlog, to: :ready_for_qa}, qa: {from: :ready_for_qa, to: :done}} }

      context "after 1 ticks" do
        before { project.tick }
        it { expect(project.column(:backlog)).to eq [story_2]}
        it { expect(project.column(:development)).to eq []}
        it { expect(project.column(:ready_for_qa)).to eq [story_1]}
        it { expect(project.column(:qa)).to eq []}
        it { expect(project.column(:done)).to eq []}
      end

      context "after 2 ticks" do
        before { 2.times{ project.tick } }
        it { expect(project.column(:backlog)).to eq [story_2]}
        it { expect(project.column(:development)).to eq []}
        it { expect(project.column(:ready_for_qa)).to eq []}
        it { expect(project.column(:qa)).to eq [story_1]}
        it { expect(project.column(:done)).to eq []}
      end

      context "after 3 ticks" do
        before { 3.times{ project.tick } }
        it { expect(project.column(:backlog)).to eq [story_2]}
        it { expect(project.column(:development)).to eq []}
        it { expect(project.column(:ready_for_qa)).to eq []}
        it { expect(project.column(:qa)).to eq []}
        it { expect(project.column(:done)).to eq [story_1]}
      end

      context "after 4 ticks" do
        before { 4.times{ project.tick } }
        it { expect(project.column(:backlog)).to eq []}
        it { expect(project.column(:development)).to eq []}
        it { expect(project.column(:ready_for_qa)).to eq [story_2]}
        it { expect(project.column(:qa)).to eq []}
        it { expect(project.column(:done)).to eq [story_1]}
      end
    end
  end
end