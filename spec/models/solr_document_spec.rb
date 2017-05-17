RSpec.describe SolrDocument, type: :model, contacts: true do

  describe "class methods" do
    describe ".find" do
      describe "when it exists" do
        before { Item.create(pid: "test:1") }
        subject { described_class.find("test:1") }
        its(:id) { is_expected.to eq("test:1") }
      end
      describe "when not found" do
        it "raises an error" do
          expect { described_class.find("foo") }.to raise_error(SolrDocument::NotFound)
        end
      end
    end
    describe ".find_by_permanent_id" do
      describe "when it exists" do
        before { Item.create(pid: "test:1", permanent_id: "foo") }
        subject { described_class.find_by_permanent_id("foo") }
        its(:id) { is_expected.to eq("test:1") }
      end
      describe "when not found" do
        it "raises an error" do
          expect { described_class.find_by_permanent_id("foo") }.to raise_error(SolrDocument::NotFound)
        end
      end
    end
  end

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

  describe "#structure" do
    context "no indexed structures" do
      it "should return nil" do
        expect(subject.structure).to be_nil
      end
    end
    context "indexed structure" do
      before { subject[Ddr::Index::Fields::STRUCTURE] = simple_structure_to_json }
      it "should return the structures map" do
        expect(subject.structure).to eq(JSON.parse(simple_structure_to_json))
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
        before { allow(subject).to receive(:structure) { JSON.parse(simple_structure_to_json) } }
        context "no structural objects with multi-res images" do
          before do
            allow(SolrDocument).to receive(:find).with('test:7') { double(multires_image_file_path: nil) }
            allow(SolrDocument).to receive(:find).with('test:8') { double(multires_image_file_path: nil) }
            allow(SolrDocument).to receive(:find).with('test:9') { double(multires_image_file_path: nil) }
          end
          its(:multires_image_file_paths) { is_expected.to match([]) }
        end
        context "structural objects with multi-res images" do
          let(:expected_result) { [ "/path/file1.ptif", "/path/file2.ptif" ] }
          before do
            allow(SolrDocument).to receive(:find).with('test:7') { double(multires_image_file_path: "/path/file1.ptif") }
            allow(SolrDocument).to receive(:find).with('test:8') { double(multires_image_file_path: nil) }
            allow(SolrDocument).to receive(:find).with('test:9') { double(multires_image_file_path: "/path/file2.ptif") }
          end
          its(:multires_image_file_paths) { is_expected.to match(expected_result) }
        end
      end
    end
  end

  describe "datastreams" do
    let(:profile) do <<-EOS
{"datastreams":{"DC":{"dsLabel":"Dublin Core Record for this object","dsVersionID":"DC1.0","dsCreateDate":"2016-02-09T12:38:56Z","dsState":"A","dsMIME":"text/xml","dsFormatURI":"http://www.openarchives.org/OAI/2.0/oai_dc/","dsControlGroup":"X","dsSize":340,"dsVersionable":true,"dsInfoType":null,"dsLocation":"duke:308221+DC+DC1.0","dsLocationType":null,"dsChecksumType":"SHA-1","dsChecksum":"69880409098d8dec1a5c41240a9daac2dd6832e0"}}}
EOS
    end
    before {
      subject[Ddr::Index::Fields::OBJECT_PROFILE] = [ profile ]
    }
    specify {
      expect(subject.has_datastream?("DC")).to be true
      expect(subject.has_datastream?("foo")).to be false
    }
  end

  describe "#streamable?" do
    specify {
      allow(subject).to receive(:has_datastream?).with(Ddr::Datastreams::STREAMABLE_MEDIA) { false }
      expect(subject).not_to be_streamable
    }
    specify {
      allow(subject).to receive(:has_datastream?).with(Ddr::Datastreams::STREAMABLE_MEDIA) { true }
      expect(subject).to be_streamable
    }
  end

  describe "#streamable_media_path" do
    specify {
      allow(subject).to receive(:streamable?) { false }
      expect(subject.streamable_media_path).to be_nil
    }
    specify {
      allow(subject).to receive(:datastreams) do
        {"streamableMedia"=>{"dsLocation"=>"file:/foo/bar/baz.txt"}}
      end
      expect(subject.streamable_media_path).to eq "/foo/bar/baz.txt"
    }
  end

  describe "#rights" do
    specify {
      obj = Item.create(rights: ["http://example.com"])
      doc = described_class.find(obj.id)
      expect(doc.rights).to eq ["http://example.com"]
    }
  end

  describe "#rights_statement" do
    let(:rights_statement) { Ddr::Models::RightsStatement.new(url: "http://example.com") }
    let(:license) { Ddr::Models::License.new(url: "http://example.com") }
    before do
      allow(Ddr::Models::RightsStatement).to receive(:get).with(:find, url: "http://example.com") do
        { url: "http://example.com" }
      end
    end
    describe "when `rights` is present" do
      specify {
        allow(subject).to receive(:rights) { ["http://example.com"] }
        expect(Ddr::Models::EffectiveLicense).not_to receive(:call).with(subject)
        expect(subject.rights_statement).to eq rights_statement
      }
    end
    describe "when `rights` is not present" do
      describe "and effective license is present" do
        before do
          allow(Ddr::Models::License).to receive(:get).with(:find, url: "http://example.com") do
            { url: "http://example.com" }
          end
        end
        specify {
          allow(subject).to receive(:rights) { [] }
          subject[Ddr::Index::Fields::LICENSE] = "http://example.com"
          expect(Ddr::Models::RightsStatement).to receive(:call).with(subject).and_call_original
          expect(Ddr::Models::EffectiveLicense).to receive(:call).with(subject).and_call_original
          expect(subject.rights_statement).to eq license
        }
      end
      describe "and `license` is not present" do
        specify {
          allow(subject).to receive(:rights) { [] }
          subject[Ddr::Index::Fields::LICENSE] = nil
          expect(Ddr::Models::RightsStatement).to receive(:call).with(subject).and_call_original
          expect(Ddr::Models::EffectiveLicense).to receive(:call).with(subject).and_call_original
          expect(subject.rights_statement).to be_nil
        }
      end
    end
  end

end
