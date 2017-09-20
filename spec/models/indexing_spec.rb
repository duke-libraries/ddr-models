module Ddr::Models
  RSpec.describe Indexing do

    subject { obj.index_fields }

    describe "general indexing" do
      let(:obj) { FactoryGirl.build(:item) }

      let(:role1) { FactoryGirl.build(:role, :curator, :person, :resource) }
      let(:role2) { FactoryGirl.build(:role, :curator, :person, :policy) }
      let(:role3) { FactoryGirl.build(:role, :editor, :group, :policy) }
      let(:role4) { FactoryGirl.build(:role, :editor, :person, :policy) }

      before do
        obj.adminMetadata.doi << "http://doi.org/10.1000/182"
        obj.affiliation << "Talk to me in the back alley."
        obj.aleph_id = "lkheajklfwbsef"
        obj.aspace_id = "aspace_dccea43034e1b8261e14cf999e86449d"
        obj.display_format = "Image"
        obj.ingested_by = "foo@bar.com"
        obj.ingestion_date = "2017-01-13T18:55:29Z"
        obj.license = "cc-by-nc-nd-40"
        obj.local_id = "foo"
        obj.permanent_id = "ark:/99999/fk4zzz"
        obj.permanent_url = "http://id.library.duke.edu/ark:/99999/fk4zzz"
        obj.rights_note = ["Public domain"]
        obj.roles.grant role1, role2, role3, role4
        obj.set_desc_metadata_values(:arranger, "Arranger Value")
        obj.set_desc_metadata_values(:category, "Category Value")
        obj.set_desc_metadata_values(:company, "Company Value")
        obj.set_desc_metadata_values(:composer, "Composer Value")
        obj.set_desc_metadata_values(:engraver, "Engraver Value")
        obj.set_desc_metadata_values(:folder, "Folder Value")
        obj.set_desc_metadata_values(:genre, "Genre Value")
        obj.set_desc_metadata_values(:illustrated, "Illustrated Value")
        obj.set_desc_metadata_values(:illustrator, "Illustrator Value")
        obj.set_desc_metadata_values(:instrumentation, "Instrumentation Value")
        obj.set_desc_metadata_values(:interviewer_name, "Interviewer Name Value")
        obj.set_desc_metadata_values(:isFormatOf, "ark:/99999/fk4aaa")
        obj.set_desc_metadata_values(:isPartOf, "RL10059CS1010")
        obj.set_desc_metadata_values(:lithographer, "Lithographer Value")
        obj.set_desc_metadata_values(:lyricist, "Lyricist Value")
        obj.set_desc_metadata_values(:medium, "Medium Value")
        obj.set_desc_metadata_values(:performer, "Performer Value")
        obj.set_desc_metadata_values(:placement_company, "Placement Company Value")
        obj.set_desc_metadata_values(:producer, "Producer Value")
        obj.set_desc_metadata_values(:product, "Product Value")
        obj.set_desc_metadata_values(:publication, "Publication Value")
        obj.set_desc_metadata_values(:roll_number, "10")
        obj.set_desc_metadata_values(:setting, "Setting Value")
        obj.set_desc_metadata_values(:subseries, "Subseries Value")
        obj.set_desc_metadata_values(:temporal, "Temporal Value")
        obj.set_desc_metadata_values(:tone, "Tone Value")
        obj.set_desc_metadata_values(:volume, "100")
      end

      specify {
        expect(subject[Indexing::ACCESS_ROLE]).to eq(obj.roles.to_json)
        expect(subject[Indexing::ADMIN_SET_TITLE]).to be_nil
        expect(subject[Indexing::AFFILIATION]).to eq(["Talk to me in the back alley."])
        expect(subject[Indexing::AFFILIATION_FACET]).to eq(["Talk to me in the back alley."])
        expect(subject[Indexing::ALEPH_ID]).to eq "lkheajklfwbsef"
        expect(subject[Indexing::ARRANGER_FACET]).to eq(["Arranger Value"])
        expect(subject[Indexing::ASPACE_ID]).to eq("aspace_dccea43034e1b8261e14cf999e86449d")
        expect(subject[Indexing::CATEGORY_FACET]).to eq(["Category Value"])
        expect(subject[Indexing::COMPANY_FACET]).to eq(["Company Value"])
        expect(subject[Indexing::COMPOSER_FACET]).to eq(["Composer Value"])
        expect(subject[Indexing::DC_IS_PART_OF]).to eq(["RL10059CS1010"])
        expect(subject[Indexing::DISPLAY_FORMAT]).to eq("Image")
        expect(subject[Indexing::DOI]).to eq(["http://doi.org/10.1000/182"])
        expect(subject[Indexing::ENGRAVER_FACET]).to eq(["Engraver Value"])
        expect(subject[Indexing::FOLDER_FACET]).to eq(["Folder Value"])
        expect(subject[Indexing::GENRE_FACET]).to eq(["Genre Value"])
        expect(subject[Indexing::ILLUSTRATED_FACET]).to eq(["Illustrated Value"])
        expect(subject[Indexing::ILLUSTRATOR_FACET]).to eq(["Illustrator Value"])
        expect(subject[Indexing::INGESTED_BY]).to eq("foo@bar.com")
        expect(subject[Indexing::INGESTION_DATE]).to eq("2017-01-13T18:55:29Z")
        expect(subject[Indexing::INSTRUMENTATION_FACET]).to eq(["Instrumentation Value"])
        expect(subject[Indexing::INTERVIEWER_NAME_FACET]).to eq(["Interviewer Name Value"])
        expect(subject[Indexing::IS_FORMAT_OF]).to eq(["ark:/99999/fk4aaa"])
        expect(subject[Indexing::LICENSE]).to eq("cc-by-nc-nd-40")
        expect(subject[Indexing::LITHOGRAPHER_FACET]).to eq(["Lithographer Value"])
        expect(subject[Indexing::LOCAL_ID]).to eq("foo")
        expect(subject[Indexing::LYRICIST_FACET]).to eq(["Lyricist Value"])
        expect(subject[Indexing::MEDIUM_FACET]).to eq(["Medium Value"])
        expect(subject[Indexing::PERFORMER_FACET]).to eq(["Performer Value"])
        expect(subject[Indexing::PERMANENT_ID]).to eq("ark:/99999/fk4zzz")
        expect(subject[Indexing::PERMANENT_URL]).to eq("http://id.library.duke.edu/ark:/99999/fk4zzz")
        expect(subject[Indexing::PLACEMENT_COMPANY_FACET]).to eq(["Placement Company Value"])
        expect(subject[Indexing::POLICY_ROLE]).to contain_exactly(role2.agent.first, role3.agent.first, role4.agent.first)
        expect(subject[Indexing::PRODUCER_FACET]).to eq(["Producer Value"])
        expect(subject[Indexing::PRODUCT_FACET]).to eq(["Product Value"])
        expect(subject[Indexing::PUBLICATION_FACET]).to eq(["Publication Value"])
        expect(subject[Indexing::RESOURCE_ROLE]).to contain_exactly(role1.agent.first)
        expect(subject[Indexing::RIGHTS_NOTE]).to eq(["Public domain"])
        expect(subject[Indexing::ROLL_NUMBER_FACET]).to eq(["10"])
        expect(subject[Indexing::SETTING_FACET]).to eq(["Setting Value"])
        expect(subject[Indexing::STREAMABLE_MEDIA_TYPE]).to be_nil
        expect(subject[Indexing::SUBSERIES_FACET]).to eq(["Subseries Value"])
        expect(subject[Indexing::TEMPORAL_FACET]).to eq(["Temporal Value"])
        expect(subject[Indexing::TONE_FACET]).to eq(["Tone Value"])
        expect(subject[Indexing::VOLUME_FACET]).to eq(["100"])
      }
    end

    describe "content-bearing object indexing" do
      let(:obj) { FactoryGirl.create(:component) }
      let!(:create_date) { Time.parse("2016-01-22T21:50:33Z") }
      before {
        allow(obj.content).to receive(:createDate) { create_date }
      }

      specify {
        expect(subject[Indexing::CONTENT_CREATE_DATE]).to eq "2016-01-22T21:50:33Z"
        expect(subject[Indexing::ATTACHED_FILES_HAVING_CONTENT]).to contain_exactly("content", "RELS-EXT", "descMetadata", "adminMetadata")
        expect(subject[Indexing::CONTENT_SIZE]).to eq 230714
        expect(subject[Indexing::CONTENT_SIZE_HUMAN]).to eq "225 KB"
        expect(subject[Indexing::MEDIA_TYPE]).to eq "image/tiff"
        expect(subject[Indexing::MEDIA_MAJOR_TYPE]).to eq "image"
        expect(subject[Indexing::MEDIA_SUB_TYPE]).to eq "tiff"
      }

      describe "streamable object indexing" do
        before {
          obj.add_file(fixture_file_upload('bird.jpg', 'image/jpeg'), 'streamableMedia')
          obj.save!
        }
        specify {
          expect(subject[Indexing::STREAMABLE_MEDIA_TYPE]).to eq "image/jpeg"
        }
      end
    end

    describe "admin set title" do
      subject { FactoryGirl.build(:item) }
      let(:coll) { FactoryGirl.create(:collection) }
      before do
        subject.parent = coll
        subject.admin_policy = coll
      end
      specify {
        expect(subject.index_fields[Indexing::ADMIN_SET_TITLE]).to eq "Foo Admin Set"
      }
    end

    describe "language name" do
      subject { FactoryGirl.build(:item) }
      before do
        subject.language = ["cym", "Not a Code"]
        subject.save!
      end
      specify {
        expect(subject.index_fields[Indexing::LANGUAGE_FACET]).to eq ["Welsh", "Not a Code"]
        expect(subject.index_fields[Indexing::LANGUAGE_NAME]).to eq ["Welsh", "Not a Code"]
      }
    end

    describe "nested path" do
      subject { FactoryGirl.build(:item) }
      before { subject.nested_path = "/foo/bar/baz" }
      specify {
        expect(subject.index_fields[Indexing::NESTED_PATH]).to eq "/foo/bar/baz"
        expect(subject.index_fields[Indexing::NESTED_PATH_TEXT]).to eq "/foo/bar/baz"
      }
    end
  end
end
