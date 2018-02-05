describe "A project" do
  let(:team) { build_list(:developer, 1) }
  subject(:project){ build(:project, backlog: backlog, team: team) }

  context "with an empty backlog" do
    let(:backlog) { [] }
    it { is_expected.to be_finished }
    it { expect(project.todo).to eq [] }
    it { expect(project.done).to eq [] }

    context "after one tick" do
      before { project.tick }
      it { is_expected.to be_finished }
      it { expect(project.todo).to eq [] }
      it { expect(project.done).to eq [] }
    end 
  end

  context "with one story(1)" do
    let(:story) { build(:story) }
    let(:backlog) { [story] }

    it { is_expected.not_to be_finished }
    it { expect(project.todo).to eq [story] }
    it { expect(project.done).to eq [] }
    it { expect(story).not_to be_done }
    
    context "after one tick" do
      before { project.tick }
      it { is_expected.to be_finished }
      it { expect(project.todo).to eq [] }
      it { expect(project.done).to eq [story] }
      it { expect(story).to be_done }
    end 
    
    context "after two ticks" do
      before { project.tick(2) }
      it { is_expected.to be_finished }
      it { expect(project.todo).to eq [] }
      it { expect(project.done).to eq [story] }
      it { expect(story).to be_done }
    end
  end

  context "with two stories(1)" do
    let(:story_1) { build(:story) }
    let(:story_2) { build(:story) }
    let(:backlog) { [story_1, story_2] }

    context "after one tick" do
      before { project.tick }
      it { is_expected.not_to be_finished }
      it { expect(project.todo).to eq [story_2] }
      it { expect(project.done).to eq [story_1] }
      it { expect(story_1).to be_done }
      it { expect(story_2).not_to be_done }
      end
    
    context "after two ticks" do
      before { project.tick(2) }
      it { is_expected.to be_finished }
      it { expect(project.todo).to eq [] }
      it { expect(project.done).to eq [story_1, story_2] }
      it { expect(story_1).to be_done }
      it { expect(story_2).to be_done }
    end
  end

  context "with one story(2)" do
    let(:story) { build(:story, expected_work: {development: 2}) }
    let(:backlog) { [story] }

    context "after one tick" do
      before { project.tick }
      it { is_expected.not_to be_finished }
      it { expect(project.todo).to eq [] }
      it { expect(project.wip).to eq [story] }
      it { expect(project.done).to eq [] }
      it { expect(story).not_to be_done }
    end
    
    context "after two ticks" do
      before { project.tick(2) }
      it { is_expected.to be_finished }
      it { expect(project.todo).to eq [] }
      it { expect(project.wip).to eq [] }
      it { expect(project.done).to eq [story] }
      it { expect(story).to be_done }
    end
  end

  context "with two stories(1) and 2 developers" do
    let(:story_1) { build(:story) }
    let(:story_2) { build(:story) }
    let(:backlog) { [story_1, story_2] }

    let(:dev_1) { build(:developer) }
    let(:dev_2) { build(:developer) }
    let(:team) { [dev_1, dev_2] }

    context "after one tick" do
      before { project.tick }
      it { is_expected.to be_finished }
      it { expect(project.todo).to eq [] }
      it { expect(project.done).to eq [story_1, story_2] }
      it { expect(story_1).to be_done }
      it { expect(story_2).to be_done }
    end
  end

  context "with development and qa" do
    let(:story) { build(:story, expected_work: {development: 1, qa: 1}) }
    let(:backlog) { [story] }

    let(:developer) { build(:developer) }
    let(:tester) { build(:tester) }
    let(:team) { [developer, tester] }

    it{ expect(story).to be_ready_for(:development) }

    context "after one tick" do
      before { project.tick }

      it{ expect(story).to be_ready_for(:qa) }
    end

    xcontext "after two ticks" do
      before { project.tick(2) }

      it{ expect(story).to be_done }
    end
  end
end
