require 'spec_helper'

RSpec.describe Collection, type: :model do

  it_behaves_like "a DDR model"

  describe "#components_from_solr" do
    subject { Collection.new(id: 'test-1') }
    before do
      allow_any_instance_of(Component).to receive(:collection_id).and_return(subject.id)
    end
    it "should return the correct component(s)" do
      component = Component.create
      docs = subject.components_from_solr
      expect(docs.size).to eq(1)
      expect(docs.first.id).to eq(component.id)
    end
  end

  describe "validation" do
    it "should require a title" do
      expect(subject).to_not be_valid
      expect(subject.errors.messages).to have_key(:dc_title)
    end
  end

  describe "creation" do
    subject { Collection.create(dc_title: [ "Test Collection" ]) }
    it "should be governed by itself" do
      expect(subject.admin_policy).to eq(subject)
    end
  end

  describe "roles granted to creator" do
    let(:user) { FactoryGirl.build(:user) }
    before { subject.grant_roles_to_creator(user) }
    it "should include Curator roles in both resource abd policy scopes" do
      expect(subject.roles.to_a).to eq([Ddr::Auth::Roles::Role.build(role_type: "Curator", agent: user.agent, scope: "resource"), Ddr::Auth::Roles::Role.build(role_type: "Curator", agent: user.agent, scope: "policy")])
    end
  end

end
