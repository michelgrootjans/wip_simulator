
describe "A project" do
  subject(:project){ Project.new(backlog) }

  context "with an empty backlog" do
    let(:backlog) { [] }
    it { is_expected.to be_finished }
  end

  context "with one story(1)" do
    let(:story) { Story.new }
    let(:backlog) { [story] }

    it { is_expected.not_to be_finished }
    it { expect(project.backlog).to eq [story] }
    it { expect(project.done).to eq [] }
    it { expect(story).not_to be_done }
    
    context "after one tick" do
      before { project.tick }
      it { is_expected.to be_finished }
      it { expect(project.backlog).to eq [] }
      it { expect(project.done).to eq [story] }
      it { expect(story).to be_done }
    end
    
    context "after two ticks" do
      before { project.tick }
      it { is_expected.to be_finished }
      it { expect(project.backlog).to eq [] }
      it { expect(project.done).to eq [story] }
      it { expect(story).to be_done }
    end
  end

  context "with two stories(1)" do
    let(:story_1) { build(:story, name: "story 1") }
    let(:story_2) { build(:story, name: "story 2") }
    let(:backlog) { [story_1, story_2] }

    it { is_expected.not_to be_finished }
    it { expect(project.backlog).to eq [story_1, story_2] }
    it { expect(project.done).to eq [] }
    it { expect(story_1).not_to be_done }
    it { expect(story_2).not_to be_done }
    
    context "after one tick" do
      before { project.tick }
      it { is_expected.not_to be_finished }
      it { expect(project.backlog).to eq [story_2] }
      it { expect(project.done).to eq [story_1] }
        it { expect(story_1).to be_done }
      it { expect(story_2).not_to be_done }
      end
    
    context "after two ticks" do
      before { project.tick(2) }
      it { is_expected.to be_finished }
      it { expect(project.backlog).to eq [] }
      it { expect(project.done).to eq [story_1, story_2] }
      it { expect(story_1).to be_done }
      it { expect(story_2).to be_done }
      end
  end
end
