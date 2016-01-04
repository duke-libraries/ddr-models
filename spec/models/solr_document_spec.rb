require 'spec_helper'

RSpec.describe SolrDocument, type: :model, contacts: true do

  describe "index field method access" do
    describe "when there is an index field" do
      before { Ddr::Index::Fields.const_set(:FOO_BAR, "foo_bar_ssim") }
      after { Ddr::Index::Fields.send(:remove_const, :FOO_BAR) }
      describe "and the field is not present" do
        its(:foo_bar) { is_expected.to be_nil }
      end
      describe "and the field is a single value (not an array)" do
        before { subject[Ddr::Index::Fields::FOO_BAR] = "foo" }
        its(:foo_bar) { is_expected.to eq("foo") }
      end
      describe "and the field value is an array" do
        before { subject[Ddr::Index::Fields::FOO_BAR] = ["foo", "bar"] }
        its(:foo_bar) { is_expected.to eq("foo, bar") }
      end
    end
    describe "when there is no index field" do
      it "should raise an exception" do
        expect { subject.foo_bar }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#admin_policy_uri" do
    describe "when is_governed_by is not set" do
      its(:admin_policy_uri) { is_expected.to be_nil }
    end
    describe "when is_governed_by is set" do
      before { subject[Ddr::Index::Fields::IS_GOVERNED_BY] = "info:fedora/test:1" }
      its(:admin_policy_uri) { should eq("info:fedora/test:1") }
    end
  end

  describe "#admin_policy" do
    describe "when there is not an admin policy relationship" do
      before { allow(subject).to receive(:admin_policy_pid) { nil } }
      its(:admin_policy) { should be_nil }
    end
    describe "where there is an admin policy relationship" do
      let(:admin_policy) { FactoryGirl.create(:collection) }
      before do
        subject[Ddr::Index::Fields::IS_GOVERNED_BY] = [ admin_policy.internal_uri ]
      end
      it "should get the admin policy document" do
        expect(subject.admin_policy.id).to eq(admin_policy.id)
      end
    end
  end

  describe "#parent_uri" do
    describe "when is_part_of is present" do
      before { subject[Ddr::Index::Fields::IS_PART_OF] = "info:fedora/test:1" }
      its(:parent_uri) { is_expected.to eq("info:fedora/test:1") }
    end
    describe "when is_part_of is not present" do
      describe "when is_member_of_collection is present" do
        before { subject[Ddr::Index::Fields::IS_MEMBER_OF_COLLECTION] = "info:fedora/test:1" }
        its(:parent_uri) { is_expected.to eq("info:fedora/test:1") }
      end
      describe "when is_member_of_collection is not present" do
        its(:parent_uri) { is_expected.to be_nil }
      end
    end
  end

  describe "#parent" do
    describe "when there is a parent URI" do
      let(:doc) { described_class.new({"id"=>"test:1"}) }
      before do
        allow(subject).to receive(:parent_uri) { "info:fedora/test:1" }
        allow(described_class).to receive(:find).with("info:fedora/test:1") { doc }
      end
      its(:parent) { is_expected.to eq(doc) }
    end
    describe "when there is no parent URI" do
      its(:parent) { is_expected.to be_nil }
    end
  end

  describe "#roles" do
    let(:json) { "[{\"role_type\":[\"Editor\"],\"agent\":[\"Editors\"],\"scope\":[\"policy\"]},{\"role_type\":[\"Contributor\"],\"agent\":[\"bob@example.com\"],\"scope\":[\"resource\"]}]" }
    before { subject[Ddr::Index::Fields::ACCESS_ROLE] = json }
    it "should deserialize the roles from JSON" do
      expect(subject.roles.to_a)
        .to eq([Ddr::Auth::Roles::Role.build(type: "Editor", agent: "Editors", scope: "policy"),
                Ddr::Auth::Roles::Role.build(type: "Contributor", agent: "bob@example.com", scope: "resource")])
    end
  end

  describe "#struct_maps" do
    context "no indexed struct maps" do
      it "should return an empty hash" do
        expect(subject.struct_maps).to be_empty
      end
    end
    context "indexed struct maps" do
      before { subject[Ddr::Index::Fields::STRUCT_MAPS] = multiple_struct_maps_structure_to_json }
      it "should return a hash of the struct maps" do
        expect(subject.struct_maps).to eq(JSON.parse(multiple_struct_maps_structure_to_json))
      end
    end
  end

  describe "#struct_map" do
    context "no indexed struct maps" do
      it "should return nil" do
        expect(subject.struct_map('default')).to be_nil
      end
    end
    context "indexed struct maps" do
      before { subject[Ddr::Index::Fields::STRUCT_MAPS] = multiple_struct_maps_structure_to_json }
      context "requested struct map is indexed" do
        it "should return the struct map" do
          expect(subject.struct_map('default')).to eq(JSON.parse(multiple_struct_maps_structure_to_json)["default"])
        end
      end
      context "requested struct map is not indexed" do
        it "should raise a KeyError" do
          expect { subject.struct_map('foo') }.to raise_error(KeyError)
        end
      end
    end
  end

  describe "contacts" do
    before do
      allow(Ddr::Models::Contact).to receive(:get).with(:find, slug: 'xa') do
        {'id'=>1, 'slug'=>'xa', 'name'=>'Contact A', 'short_name'=>'A'}
      end
      allow(Ddr::Models::Contact).to receive(:get).with(:find, slug: 'yb') do
        {'id'=>1, 'slug'=>'yb', 'name'=>'Contact B', 'short_name'=>'B'}
      end
    end
    describe "#research_help" do
      context "object has research help contact" do
        before { subject[Ddr::Index::Fields::RESEARCH_HELP_CONTACT] = 'yb' }
        it "should return the object's research help contact" do
          expect(subject.research_help.slug).to eq('yb')
        end
      end
      context "object does not have research help contact" do
        context "collection has research help contact" do
          let(:admin_policy) { described_class.new({Ddr::Index::Fields::RESEARCH_HELP_CONTACT=>["xa"]}) }
          before do
            allow(subject).to receive(:admin_policy) { admin_policy }
          end
          it "should return the collection's research help contact" do
            expect(subject.research_help.slug).to eq("xa")
          end
        end
        context "collection does not have research help contact" do
          it "should return nil" do
            expect(subject.research_help).to be_nil
          end
        end
      end
    end
  end

  describe "structural metadata" do
    describe "#multires_image_file_paths" do
      context "no structural metadata" do
        its(:multires_image_file_paths) { is_expected.to match([]) }
      end
      context "structural metadata" do
        let(:struct_map) do
          {"type"=>"default", "divs"=>
            [{"id"=>"viccb010010010", "label"=>"1", "order"=>"1", "type"=>"Image", "fptrs"=>["test:5"], "divs"=>[]},
             {"id"=>"viccb010020010", "label"=>"2", "order"=>"2", "type"=>"Image", "fptrs"=>["test:6"], "divs"=>[]},
             {"id"=>"viccb010030010", "label"=>"3", "order"=>"3", "type"=>"Image", "fptrs"=>["test:7"], "divs"=>[]}]
          }
        end
        before { allow(subject).to receive(:struct_map) { struct_map } }
        context "no structural objects with multi-res images" do
          before do
            allow(SolrDocument).to receive(:find).with('test:5') { double(multires_image_file_path: nil) }
            allow(SolrDocument).to receive(:find).with('test:6') { double(multires_image_file_path: nil) }
            allow(SolrDocument).to receive(:find).with('test:7') { double(multires_image_file_path: nil) }
          end
          its(:multires_image_file_paths) { is_expected.to match([]) }
        end
        context "structural objects with multi-res images" do
          let(:expected_result) { [ "/path/file1.ptif", "/path/file2.ptif" ] }
          before do
            allow(SolrDocument).to receive(:find).with('test:5') { double(multires_image_file_path: "/path/file1.ptif") }
            allow(SolrDocument).to receive(:find).with('test:6') { double(multires_image_file_path: nil) }
            allow(SolrDocument).to receive(:find).with('test:7') { double(multires_image_file_path: "/path/file2.ptif") }
          end
          its(:multires_image_file_paths) { is_expected.to match(expected_result) }
        end
      end
    end
  end
end
