describe "A story" do
  subject(:story){ build(:story, expected_work: expected_work) }

  context "with only development work" do
    let(:expected_work){ {development: 1} }

    it { is_expected.to be_ready_for(:development) }
    it { is_expected.not_to be_done_for(:development) }
    it { is_expected.not_to be_done }

    context "after development" do
      before { story.do_work(:development) }
      it { is_expected.not_to be_ready_for(:development) }
      it { is_expected.to be_done_for(:development) }
      it { is_expected.to be_done }
      end
  end

  context "with development and qa work" do
    let(:expected_work){ {development: 1, qa: 1} }

    it { is_expected.to be_ready_for(:development) }
    it { is_expected.not_to be_done_for(:development) }
    it { is_expected.not_to be_ready_for(:qa) }
    it { is_expected.not_to be_done_for(:qa) }
    it { is_expected.not_to be_done }

    context "after development" do
      before { story.do_work(:development) }
      it { is_expected.not_to be_ready_for(:development) }
      it { is_expected.to be_done_for(:development) }
      it { is_expected.to be_ready_for(:qa) }
      it { is_expected.not_to be_done_for(:qa) }
      it { is_expected.not_to be_done }
    end

    context "can't do qa before development" do
      before { story.do_work(:qa) }
      it { is_expected.to be_ready_for(:development) }
      it { is_expected.not_to be_done_for(:development) }
      it { is_expected.not_to be_ready_for(:qa) }
      it { is_expected.not_to be_done_for(:qa) }
      it { is_expected.not_to be_done }
    end

    context "after development and qa" do
      before do
        story.do_work(:development)
        story.do_work(:qa)
      end

      it { is_expected.not_to be_ready_for(:development) }
      it { is_expected.to be_done_for(:development) }
      it { is_expected.not_to be_ready_for(:qa) }
      it { is_expected.to be_done_for(:qa) }
      it { is_expected.to be_done }
    end

  end
end