describe "Project initialization" do
  subject(:project){ Project.new }
  it "with symbol-based process" do
    project.process = {development: {from: :todo, to: :done}}
    expect(project.columns.keys).to eq [:todo, :development, :done]
  end

  it "with string-based process" do
    project.process = {"development" => {"from" => "todo", "to" => "done"}}
    expect(project.columns.keys).to eq [:todo, :development, :done]
  end
end

describe "A project" do
  subject(:project) { build(:project, team: team, planning: planning, process: process) }
  let(:process) { {development: {from: :backlog, to: :done}} }

  context "with one developer and one develpment(1) story" do
    let(:team) { [build(:developer)] }
    let(:story) { build(:story, expected_work: {development: 1})}
    let(:planning) { [story] }

    it { expect(project.column(:backlog)).to eq [story]}
    it { expect(project.column(:development)).to eq []}
    it { expect(project.column(:done)).to eq []}
    it { is_expected.not_to be_done }

    context "after one tick" do
      before { project.tick }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:done)).to eq [story]}
      it { is_expected.to be_done }
    end
  end

  context "with one developer and one develpment(2) story" do
    let(:team) { [build(:developer)] }
    let(:story) { build(:story, expected_work: {development: 2})}
    let(:planning) { [story] }

    it { expect(project.column(:backlog)).to eq [story]}
    it { expect(project.column(:development)).to eq []}
    it { expect(project.column(:done)).to eq []}
    it { is_expected.not_to be_done }

    context "after one tick" do
      before { project.tick }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq [story]}
      it { expect(project.column(:done)).to eq []}
      it { is_expected.not_to be_done }
    end

    context "after two ticks" do
      before { 2.times{project.tick} }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:done)).to eq [story]}
      it { is_expected.to be_done }
    end
  end

  context "with one developer and two develpment(1) stories" do
    let(:team) { [build(:developer)] }
    let(:story_1) { build(:story, expected_work: {development: 1})}
    let(:story_2) { build(:story, expected_work: {development: 1})}
    let(:planning) { [story_1, story_2] }

    it { expect(project.column(:backlog)).to eq [story_1, story_2]}
    it { expect(project.column(:development)).to eq []}
    it { expect(project.column(:done)).to eq []}
    it { is_expected.not_to be_done }

    context "after one tick" do
      before { project.tick }

      it { expect(project.column(:backlog)).to eq [story_2]}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:done)).to eq [story_1]}
      it { is_expected.not_to be_done }
    end

    context "after two ticks" do
      before { 2.times{project.tick} }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:done)).to eq [story_1, story_2]}
      it { is_expected.to be_done }
    end
  end

  context "with two developers and two development(1) stories" do
    let(:team) { build_list(:developer, 2) }
    let(:story_1) { build(:story, expected_work: {development: 1})}
    let(:story_2) { build(:story, expected_work: {development: 1})}
    let(:planning) { [story_1, story_2] }

    it { expect(project.column(:backlog)).to eq [story_1, story_2]}
    it { expect(project.column(:development)).to eq []}
    it { expect(project.column(:done)).to eq []}
    it { is_expected.not_to be_done }

    context "after one tick" do
      before { project.tick }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:done)).to eq [story_1, story_2]}
      it { is_expected.to be_done }
    end
  end

  context "with two developers and two development(3-2) stories" do
    let(:team) { build_list(:developer, 2) }
    let(:story_1) { build(:story, expected_work: {development: 3})}
    let(:story_2) { build(:story, expected_work: {development: 2})}
    let(:planning) { [story_1, story_2] }

    it { expect(project.column(:backlog)).to eq [story_1, story_2]}
    it { expect(project.column(:development)).to eq []}
    it { expect(project.column(:done)).to eq []}
    it { is_expected.not_to be_done }

    context "after one tick" do
      before { project.tick }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq [story_1, story_2]}
      it { expect(project.column(:done)).to eq []}
      it { is_expected.not_to be_done }
    end

    context "after two ticks" do
      before { 2.times{project.tick} }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq [story_1]}
      it { expect(project.column(:done)).to eq [story_2]}
      it { is_expected.not_to be_done }
    end

    context "after three ticks" do
      before { 3.times{project.tick} }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:done)).to eq [story_2, story_1]}
      it { is_expected.to be_done }
    end
  end

  context "with one developer and one tester and one story(dev: 1, qa: 1)" do
    let(:team) { [build(:developer), build(:tester)] }
    let(:story) { build(:story, expected_work: {development: 1, qa: 1})}
    let(:planning) { [story] }
    let(:process) {{
        development: {from: :backlog,      to: :ready_for_qa},
        qa:          {from: :ready_for_qa, to: :done}
    }}

    it { expect(project.column(:backlog)).to eq [story]}
    it { expect(project.column(:development)).to eq []}
    it { expect(project.column(:ready_for_qa)).to eq []}
    it { expect(project.column(:qa)).to eq []}
    it { expect(project.column(:done)).to eq []}
    it { is_expected.not_to be_done }

    context "after one tick" do
      before { project.tick }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:ready_for_qa)).to eq [story]}
      it { expect(project.column(:qa)).to eq []}
      it { expect(project.column(:done)).to eq []}
      it { is_expected.not_to be_done }
    end

    context "after two ticks" do
      before { 2.times{project.tick} }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:ready_for_qa)).to eq []}
      it { expect(project.column(:qa)).to eq []}
      it { expect(project.column(:done)).to eq [story]}
      it { is_expected.to be_done }
    end
  end

  context "with one developer and one tester and two stories(dev: 1, qa: 1)" do
    let(:team) { [build(:developer), build(:tester)] }
    let(:story_1) { build(:story, expected_work: {development: 1, qa: 1})}
    let(:story_2) { build(:story, expected_work: {development: 1, qa: 1})}
    let(:planning) { [story_1, story_2] }
    let(:process) {{
        development: {from: :backlog,      to: :ready_for_qa},
        qa:          {from: :ready_for_qa, to: :done}
    }}

    it { expect(project.column(:backlog)).to eq [story_1, story_2]}
    it { expect(project.column(:development)).to eq []}
    it { expect(project.column(:ready_for_qa)).to eq []}
    it { expect(project.column(:qa)).to eq []}
    it { expect(project.column(:done)).to eq []}
    it { is_expected.not_to be_done }

    context "after one tick" do
      before { project.tick }

      it { expect(project.column(:backlog)).to eq [story_2]}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:ready_for_qa)).to eq [story_1]}
      it { expect(project.column(:qa)).to eq []}
      it { expect(project.column(:done)).to eq []}
      it { is_expected.not_to be_done }
    end

    context "after two ticks" do
      before { 2.times{project.tick} }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:ready_for_qa)).to eq [story_2]}
      it { expect(project.column(:qa)).to eq []}
      it { expect(project.column(:done)).to eq [story_1]}
      it { is_expected.not_to be_done }
    end

    context "after three ticks" do
      before { 3.times{project.tick} }

      it { expect(project.column(:backlog)).to eq []}
      it { expect(project.column(:development)).to eq []}
      it { expect(project.column(:ready_for_qa)).to eq []}
      it { expect(project.column(:qa)).to eq []}
      it { expect(project.column(:done)).to eq [story_1, story_2]}
      it { is_expected.to be_done }
    end
  end
end
