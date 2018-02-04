describe "A developer" do
  subject(:team_member) { build(:team_member, skill: skill) }
  let(:story) { build(:story, expected_work: work) }
  let(:work) { {skill => 1} }
  let(:skill) { Faker::Lorem.word }

  it { is_expected.not_to be_busy}

  context "who takes a story" do
    before{ team_member.take(story) }
    it { is_expected.to be_busy}
    it { expect(story).to be_ready_for(skill) }

    context "and works on it" do
      before{ team_member.work }
      it { is_expected.not_to be_busy}
      it { expect(story).to be_done }
    end
  end
end
