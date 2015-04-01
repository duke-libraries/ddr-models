RSpec.shared_examples "an agent" do

  its(:type) { is_expected.to eq([type]) }
  its(:agent_type) { is_expected.to eq(agent_type) }
  its(:agent_name) { is_expected.to eq(subject.name.first) }
  its(:to_s) { is_expected.to eq(subject.name.first) }

  it { is_expected.to be_valid }

  describe "isomorphism" do
    it { is_expected.to eq(described_class.build(subject.name.first)) }
    it { is_expected.to eq(described_class.build(subject)) }
    it { is_expected.not_to eq(FactoryGirl.build(agent_type)) }
  end

end
