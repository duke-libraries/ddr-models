require 'spec_helper'

RSpec.describe Collection, type: :model do

  it_behaves_like "a DDR model"

  it_behaves_like "it has an association", :has_many, :children, :is_member_of_collection, "Item"

  it_behaves_like "it has an association", :has_many, :targets, :is_external_target_for, "Target"

  describe "terms delegated to defaultRights" do
    before do
      subject.default_license_title = "License Title"
      subject.default_license_description = "License Description"
      subject.default_license_url = "http://library.duke.edu"
    end
    it "should set the terms correctly" do
      expect(subject.defaultRights.license.title.first).to eq("License Title")
      expect(subject.defaultRights.license.description.first).to eq("License Description")
      expect(subject.defaultRights.license.url.first).to eq("http://library.duke.edu")
    end
    it "should index the terms" do
      expect(subject.to_solr[Ddr::IndexFields::DEFAULT_LICENSE_TITLE]).to eq("License Title")
      expect(subject.to_solr[Ddr::IndexFields::DEFAULT_LICENSE_DESCRIPTION]).to eq("License Description")
      expect(subject.to_solr[Ddr::IndexFields::DEFAULT_LICENSE_URL]).to eq("http://library.duke.edu")
    end
  end

  describe "#components_from_solr" do
    subject { Collection.new(pid: 'test:1') }
    before do
      allow_any_instance_of(Component).to receive(:collection_uri).and_return(subject.internal_uri)
    end
    it "should return the correct component(s)" do
      component = Component.create
      docs = subject.components_from_solr
      expect(docs.size).to eq(1)
      expect(docs.first.id).to eq(component.pid)
    end
  end

  describe "validation" do
    it "should require a title" do
      expect(subject).to_not be_valid
      expect(subject.errors.messages).to have_key(:title)
    end
  end

  describe "creation" do
    subject { Collection.create(title: [ "Test Collection" ]) }
    it "should be governed by itself" do
      expect(subject.admin_policy).to eq(subject)
    end
  end

  describe "policy roles" do
    subject { FactoryGirl.build(:collection) }
    describe "when the default permissions change" do
      it "should update the policy roles" do
        subject.default_permissions = [{access: "edit", type: "group", name: "Editors"},
                                       {access: "discover", type: "group", name: "public"},
                                       {access: "read", type: "person", name: "bob@example.com"}]
        expect { subject.save }.to change { subject.roles.where(scope: "policy") }
          .from([])
          .to(include(Ddr::Auth::Roles::Role.build(type: "Viewer", agent: "bob@example.com", scope: "policy"),
                      Ddr::Auth::Roles::Role.build(type: "Editor", agent: "Editors", scope: "policy"),
                      Ddr::Auth::Roles::Role.build(type: "Viewer", agent: "public", scope: "policy")))
      end
    end

    describe "when default permissions haven't changed" do
      it "shouldn't change the policy roles" do
        subject.title = ["Changed Title"]
        expect { subject.save }.not_to change { subject.roles.where(scope: "Policy") }
      end
    end
  end

end
