require 'spec_helper'

RSpec.describe SolrDocument, type: :model, contacts: true do

  describe "#inherited_license" do
    let(:apo_solr_response) { [{"system_create_dtsi"=>"2015-03-10T15:20:16Z", "system_modified_dtsi"=>"2015-03-10T15:21:50Z", "object_state_ssi"=>"A", "active_fedora_model_ssi"=>"Collection", "id"=>"changeme:224", "object_profile_ssm"=>["{\"datastreams\":{\"DC\":{\"dsLabel\":\"Dublin Core Record for this object\",\"dsVersionID\":\"DC1.0\",\"dsCreateDate\":\"2015-03-10T15:20:16Z\",\"dsState\":\"A\",\"dsMIME\":\"text/xml\",\"dsFormatURI\":\"http://www.openarchives.org/OAI/2.0/oai_dc/\",\"dsControlGroup\":\"X\",\"dsSize\":341,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+DC+DC1.0\",\"dsLocationType\":null,\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"0555f020bbfc94c07745f530af4195fed9cf4e4ba539a30727f2d2d5743627be\"},\"RELS-EXT\":{\"dsLabel\":\"Fedora Object-to-Object Relationship Metadata\",\"dsVersionID\":\"RELS-EXT.1\",\"dsCreateDate\":\"2015-03-10T15:20:18Z\",\"dsState\":\"A\",\"dsMIME\":\"application/rdf+xml\",\"dsFormatURI\":null,\"dsControlGroup\":\"X\",\"dsSize\":417,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+RELS-EXT+RELS-EXT.1\",\"dsLocationType\":null,\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"6a7c2621534cd1cb28d9cfa7e45bb128a1f3c05028e29def4dea479be9596d7d\"},\"descMetadata\":{\"dsLabel\":\"Descriptive Metadata for this object\",\"dsVersionID\":\"descMetadata.1\",\"dsCreateDate\":\"2015-03-10T15:20:18Z\",\"dsState\":\"A\",\"dsMIME\":\"application/n-triples\",\"dsFormatURI\":null,\"dsControlGroup\":\"M\",\"dsSize\":80,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+descMetadata+descMetadata.1\",\"dsLocationType\":\"INTERNAL_ID\",\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"bbba526a1ca47f19dfe110f25a0a721bda481dc414f7ec89e3f02c5562eaa9a2\"},\"rightsMetadata\":{\"dsLabel\":null,\"dsVersionID\":\"rightsMetadata.0\",\"dsCreateDate\":\"2015-03-10T15:20:17Z\",\"dsState\":\"A\",\"dsMIME\":\"text/xml\",\"dsFormatURI\":null,\"dsControlGroup\":\"M\",\"dsSize\":550,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+rightsMetadata+rightsMetadata.0\",\"dsLocationType\":\"INTERNAL_ID\",\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"210d5a228bd96e22b20723de1dd20ea8d897252063713d0815369c49045c5c05\"},\"properties\":{},\"thumbnail\":{},\"adminMetadata\":{},\"defaultRights\":{\"dsLabel\":null,\"dsVersionID\":\"defaultRights.0\",\"dsCreateDate\":\"2015-03-10T15:21:50Z\",\"dsState\":\"A\",\"dsMIME\":\"text/xml\",\"dsFormatURI\":null,\"dsControlGroup\":\"M\",\"dsSize\":634,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+defaultRights+defaultRights.0\",\"dsLocationType\":\"INTERNAL_ID\",\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"1a2d9e665228d5e3cbf5f8ddd0d641172c20f98b4e05d62f741b7b9010696ad0\"}},\"objLabel\":null,\"objOwnerId\":\"fedoraAdmin\",\"objModels\":[\"info:fedora/afmodel:Collection\",\"info:fedora/fedora-system:FedoraObject-3.0\"],\"objCreateDate\":\"2015-03-10T15:20:16Z\",\"objLastModDate\":\"2015-03-10T15:20:18Z\",\"objDissIndexViewURL\":\"http://localhost:8983/fedora/objects/changeme%3A224/methods/fedora-system%3A3/viewMethodIndex\",\"objItemIndexViewURL\":\"http://localhost:8983/fedora/objects/changeme%3A224/methods/fedora-system%3A3/viewItemIndex\",\"objState\":\"A\"}"], "title_tesim"=>["Test Collection"], "edit_access_person_ssim"=>["coblej@duke.edu"], "inheritable_read_access_group_ssim"=>["public"], "is_governed_by_ssim"=>["info:fedora/changeme:224"], "has_model_ssim"=>["info:fedora/afmodel:Collection"], "title_ssi"=>"Test Collection", "internal_uri_ssi"=>"info:fedora/changeme:224", "default_license_description_tesim"=>["Default License Description"], "default_license_title_tesim"=>["Default License Title"], "default_license_url_tesim"=>["http://test.license.org/"], "_version_"=>1495270331036729344, "timestamp"=>"2015-03-10T15:21:50.793Z"}] }
    before do
      allow(subject).to receive(:admin_policy_pid).and_return('changeme:224')
      allow(ActiveFedora::SolrService).to receive(:query).and_return(apo_solr_response)
    end
    it "should return a hash of the default license attributes of the governing object" do
      expect(subject.inherited_license).to include(title: "Default License Title",
                                                    description: "Default License Description",
                                                    url: "http://test.license.org/")
    end
  end

  describe "#permanent_id" do
    before { subject[Ddr::IndexFields::PERMANENT_ID] = "foo" }
    its(:permanent_id) { is_expected.to eq("foo") }
  end

  describe "#admin_policy" do
    describe "when there is not admin policy relationship" do
      its(:admin_policy) { should be_nil }
    end
    describe "where there is an admin policy relationship" do
      let(:admin_policy) { FactoryGirl.create(:collection) }
      before do
        subject[Ddr::IndexFields::IS_GOVERNED_BY] = [ admin_policy.internal_uri ]
      end
      it "should get the admin policy document" do
        expect(subject.admin_policy.id).to eq(admin_policy.id)
      end
    end
  end

  describe "#local_id" do
    before { subject[Ddr::IndexFields::LOCAL_ID] = "abcdef" }
    its(:local_id) { is_expected.to eq("abcdef") }
  end

  describe "#admin_set" do
    before { subject[Ddr::IndexFields::ADMIN_SET] = "foobar" }
    its(:admin_set) { should eq("foobar") }
  end

  describe "#roles" do
    let(:json) { "[{\"role_type\":[\"Editor\"],\"agent\":[\"Editors\"],\"scope\":[\"policy\"]},{\"role_type\":[\"Contributor\"],\"agent\":[\"bob@example.com\"],\"scope\":[\"resource\"]}]" }
    before { subject[Ddr::IndexFields::ACCESS_ROLE] = json }
    it "should deserialize the roles from JSON" do
      expect(subject.roles.to_a)
        .to eq([Ddr::Auth::Roles::Role.build(type: "Editor", agent: "Editors", scope: "policy"),
                Ddr::Auth::Roles::Role.build(type: "Contributor", agent: "bob@example.com", scope: "resource")])
    end
  end

  describe "#display_format" do
    before { subject[Ddr::IndexFields::DISPLAY_FORMAT] = "Image" }
    its(:display_format) { should eq("Image") }
  end

  describe "#struct_maps" do
    context "no indexed struct maps" do
      it "should return an empty hash" do
        expect(subject.struct_maps).to be_empty
      end
    end
    context "indexed struct maps" do
      before { subject[Ddr::IndexFields::STRUCT_MAPS] = multiple_struct_maps_structure_to_json }
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
      before { subject[Ddr::IndexFields::STRUCT_MAPS] = multiple_struct_maps_structure_to_json }
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

  describe "#display_format" do
    before { subject[Ddr::IndexFields::DISPLAY_FORMAT] = "Image" }
    its(:display_format) { should eq("Image") }
  end

  describe "contacts" do
    before do
      allow(YAML).to receive(:load_file) { { 'xa' => { 'name' => 'Contact A', 'short_name' => 'A' },
                                             'yb' => { 'name' => 'Contact B', 'short_name' => 'B' } } }
      Ddr::Contacts.load_contacts
    end
    describe "#research_help" do
      context "object has research help contact" do
        before { subject[Ddr::IndexFields::RESEARCH_HELP_CONTACT] = 'yb' }
        it "should return the object's research help contact" do
          expect(subject.research_help.slug).to eq('yb')
        end
      end
      context "object does not have research help contact" do
        context "collection has research help contact" do
          let(:apo_solr_response) { [{"system_create_dtsi"=>"2015-03-10T15:20:16Z", "system_modified_dtsi"=>"2015-03-10T15:21:50Z", "object_state_ssi"=>"A", "active_fedora_model_ssi"=>"Collection", "id"=>"changeme:224", "object_profile_ssm"=>["{\"datastreams\":{\"DC\":{\"dsLabel\":\"Dublin Core Record for this object\",\"dsVersionID\":\"DC1.0\",\"dsCreateDate\":\"2015-03-10T15:20:16Z\",\"dsState\":\"A\",\"dsMIME\":\"text/xml\",\"dsFormatURI\":\"http://www.openarchives.org/OAI/2.0/oai_dc/\",\"dsControlGroup\":\"X\",\"dsSize\":341,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+DC+DC1.0\",\"dsLocationType\":null,\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"0555f020bbfc94c07745f530af4195fed9cf4e4ba539a30727f2d2d5743627be\"},\"RELS-EXT\":{\"dsLabel\":\"Fedora Object-to-Object Relationship Metadata\",\"dsVersionID\":\"RELS-EXT.1\",\"dsCreateDate\":\"2015-03-10T15:20:18Z\",\"dsState\":\"A\",\"dsMIME\":\"application/rdf+xml\",\"dsFormatURI\":null,\"dsControlGroup\":\"X\",\"dsSize\":417,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+RELS-EXT+RELS-EXT.1\",\"dsLocationType\":null,\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"6a7c2621534cd1cb28d9cfa7e45bb128a1f3c05028e29def4dea479be9596d7d\"},\"descMetadata\":{\"dsLabel\":\"Descriptive Metadata for this object\",\"dsVersionID\":\"descMetadata.1\",\"dsCreateDate\":\"2015-03-10T15:20:18Z\",\"dsState\":\"A\",\"dsMIME\":\"application/n-triples\",\"dsFormatURI\":null,\"dsControlGroup\":\"M\",\"dsSize\":80,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+descMetadata+descMetadata.1\",\"dsLocationType\":\"INTERNAL_ID\",\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"bbba526a1ca47f19dfe110f25a0a721bda481dc414f7ec89e3f02c5562eaa9a2\"},\"rightsMetadata\":{\"dsLabel\":null,\"dsVersionID\":\"rightsMetadata.0\",\"dsCreateDate\":\"2015-03-10T15:20:17Z\",\"dsState\":\"A\",\"dsMIME\":\"text/xml\",\"dsFormatURI\":null,\"dsControlGroup\":\"M\",\"dsSize\":550,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+rightsMetadata+rightsMetadata.0\",\"dsLocationType\":\"INTERNAL_ID\",\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"210d5a228bd96e22b20723de1dd20ea8d897252063713d0815369c49045c5c05\"},\"properties\":{},\"thumbnail\":{},\"adminMetadata\":{},\"defaultRights\":{\"dsLabel\":null,\"dsVersionID\":\"defaultRights.0\",\"dsCreateDate\":\"2015-03-10T15:21:50Z\",\"dsState\":\"A\",\"dsMIME\":\"text/xml\",\"dsFormatURI\":null,\"dsControlGroup\":\"M\",\"dsSize\":634,\"dsVersionable\":true,\"dsInfoType\":null,\"dsLocation\":\"changeme:224+defaultRights+defaultRights.0\",\"dsLocationType\":\"INTERNAL_ID\",\"dsChecksumType\":\"SHA-256\",\"dsChecksum\":\"1a2d9e665228d5e3cbf5f8ddd0d641172c20f98b4e05d62f741b7b9010696ad0\"}},\"objLabel\":null,\"objOwnerId\":\"fedoraAdmin\",\"objModels\":[\"info:fedora/afmodel:Collection\",\"info:fedora/fedora-system:FedoraObject-3.0\"],\"objCreateDate\":\"2015-03-10T15:20:16Z\",\"objLastModDate\":\"2015-03-10T15:20:18Z\",\"objDissIndexViewURL\":\"http://localhost:8983/fedora/objects/changeme%3A224/methods/fedora-system%3A3/viewMethodIndex\",\"objItemIndexViewURL\":\"http://localhost:8983/fedora/objects/changeme%3A224/methods/fedora-system%3A3/viewItemIndex\",\"objState\":\"A\"}"], "title_tesim"=>["Test Collection"], "edit_access_person_ssim"=>["coblej@duke.edu"], "inheritable_read_access_group_ssim"=>["public"], "is_governed_by_ssim"=>["info:fedora/changeme:224"], "has_model_ssim"=>["info:fedora/afmodel:Collection"], "title_ssi"=>"Test Collection", "internal_uri_ssi"=>"info:fedora/changeme:224", Ddr::IndexFields::RESEARCH_HELP_CONTACT=>"xa", "_version_"=>1495270331036729344, "timestamp"=>"2015-03-10T15:21:50.793Z"}] }
          before do
            allow(subject).to receive(:admin_policy_pid).and_return('changeme:224')
            allow(ActiveFedora::SolrService).to receive(:query).and_return(apo_solr_response)
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

end
