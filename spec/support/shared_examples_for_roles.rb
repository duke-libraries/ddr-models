RSpec.shared_examples "a role" do

  let(:person) { FactoryGirl.build(:person) }
  subject { described_class.build(person: person, scope: :resource) }
  it { is_expected.to be_a(described_class) }
  its(:role_type) { is_expected.to eq(role_type) }
  its(:type) { is_expected.to eq([type]) }
  its(:scope_type) { is_expected.to eq(:resource) }
  its(:agent_name) { is_expected.to eq(person.name.first) }
  its(:agent_type) { is_expected.to eq(:person) }
  its(:to_h) { is_expected.to eq({type: role_type, person: person.name.first, scope: :resource}) }
  its(:to_hash) { is_expected.to eq({type: role_type, person: person.name.first, scope: :resource}) }
  its(:permissions) { is_expected.to match_array(permissions) }

  describe "isomorphism" do
    describe "two roles of the same type that have the same agent and scope" do
      let(:other) { described_class.build(person: subject.agent_name, scope: :resource) }
      it { is_expected.to eq(other) }
    end
    describe "two roles of the same type that have a different agent or scope" do
      let(:person3) { FactoryGirl.build(:person) }
      let(:role2) { described_class.build(person: person, scope: :policy) }
      let(:role3) { described_class.build(person: person3, scope: :resource) }
      it { is_expected.not_to eq(role2) }
      it { is_expected.not_to eq(role3) }
    end
    describe "two roles of different types" do
      before do
        class OtherRole < Ddr::Auth::Roles::Role
          configure type: RDF::URI("http://example.com/roles/Other")
        end
      end
      after do
        Object.send(:remove_const, :OtherRole)
      end
      let(:role2) { OtherRole.build(person: person, scope: :resource) }
      it { is_expected.not_to eq(role2) }
    end
  end

end
