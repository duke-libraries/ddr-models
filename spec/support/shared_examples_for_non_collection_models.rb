RSpec.shared_examples "a non-collection model" do
  describe "roles granted to creator" do
    subject { described_class.new }
    let(:user) { FactoryGirl.build(:user) }
    before { subject.grant_roles_to_creator(user) }
    it "should include the Editor role in resource scope" do
      expect(subject.roles.to_a).to eq([Ddr::Auth::Roles::Role.new(role_type: "Editor", agent: user.agent, scope: "resource")])
    end
  end
end
