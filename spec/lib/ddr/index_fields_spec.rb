RELATIONSHIPS = [ :has_model, 
                  :is_attached_to, 
                  :is_external_target_for, 
                  :is_governed_by, 
                  :is_member_of, 
                  :is_member_of_collection, 
                  :is_part_of ]

module Ddr
  RSpec.describe IndexFields do

    subject { described_class }

    describe "Hydra indexing" do
      it ":active_fedora_model" do
        expect(subject.active_fedora_model).to eq("active_fedora_model_ssi")
        expect(subject::ACTIVE_FEDORA_MODEL).to eq("active_fedora_model_ssi")
      end
      it ":system_create" do
        expect(subject.system_create).to eq("system_create_dtsi")
        expect(subject::OBJECT_CREATE_DATE).to eq("system_create_dtsi")
      end
      it ":system_modified" do
        expect(subject.system_modified).to eq("system_modified_dtsi")
        expect(subject::OBJECT_MODIFIED_DATE).to eq("system_modified_dtsi")
      end
      it ":object_state" do
        expect(subject.object_state).to eq("object_state_ssi")
        expect(subject::OBJECT_STATE).to eq("object_state_ssi")
      end    
      it ":object_profile" do
        expect(subject.object_profile).to eq("object_profile_ssm")
        expect(subject::OBJECT_PROFILE).to eq("object_profile_ssm")
      end
    end

    describe "relationships" do
      RELATIONSHIPS.each do |rel|
        it ":#{rel}" do
          expect(subject.send(rel)).to eq("#{rel}_ssim")
          expect(subject.const_get(rel.to_s.upcase.to_sym)).to eq("#{rel}_ssim")
        end
      end
    end

    describe "content information" do      
      it "COLLECTION_URI" do
        expect(subject::COLLECTION_URI).to eq("collection_uri_ssim")
      end
      it "CONTENT_CONTROL_GROUP" do
        expect(subject::CONTENT_CONTROL_GROUP).to eq("content_control_group_teim")
      end
      it "CONTENT_METADATA_PARSED" do
        expect(subject::CONTENT_METADATA_PARSED).to eq("content_metadata_parsed_ssim")
      end
      it "CONTENT_SIZE" do
        expect(subject::CONTENT_SIZE).to eq("content_size_isi")
      end
      it "CONTENT_SIZE_HUMAN" do
        expect(subject::CONTENT_SIZE_HUMAN).to eq("content_size_human_ssim")
      end
      it "IDENTIFIER" do
        expect(subject::IDENTIFIER).to eq("identifier_ssi")
      end
      it "INTERNAL_URI" do
        expect(subject::INTERNAL_URI).to eq("internal_uri_ssi")
      end
      it "LAST_FIXITY_CHECK_ON" do
        expect(subject::LAST_FIXITY_CHECK_ON).to eq("last_fixity_check_on_dtsi")
      end
      it "LAST_FIXITY_CHECK_OUTCOME" do
        expect(subject::LAST_FIXITY_CHECK_OUTCOME).to eq("last_fixity_check_outcome_ssim")
      end
      it "LAST_VIRUS_CHECK_ON" do
        expect(subject::LAST_VIRUS_CHECK_ON).to eq("last_virus_check_on_dtsi")
      end
      it "LAST_VIRUS_CHECK_OUTCOME" do
        expect(subject::LAST_VIRUS_CHECK_OUTCOME).to eq("last_virus_check_outcome_ssim")
      end
      it "MEDIA_SUB_TYPE" do
        expect(subject::MEDIA_SUB_TYPE).to eq("content_media_sub_type_sim")
      end
      it "MEDIA_MAJOR_TYPE" do
        expect(subject::MEDIA_MAJOR_TYPE).to eq("content_media_major_type_sim")
      end
      it "MEDIA_TYPE" do
        expect(subject::MEDIA_TYPE).to eq("content_media_type_ssim")
      end
      it "TITLE" do
        expect(subject::TITLE).to eq("title_ssi")
      end
    end

    describe "defined attributes" do
      it ":permanent_id" do
        expect(subject.permanent_id).to eq("admin_metadata__permanent_id_ssi")
        expect(subject::PERMANENT_ID).to eq("admin_metadata__permanent_id_ssi")
      end
      it ":permanent_url" do
        expect(subject.permanent_url).to eq("admin_metadata__permanent_url_ssi")
        expect(subject::PERMANENT_URL).to eq("admin_metadata__permanent_url_ssi")
      end
      it ":workflow_state" do
        expect(subject.workflow_state).to eq("admin_metadata__workflow_state_ssi")
        expect(subject::WORKFLOW_STATE).to eq("admin_metadata__workflow_state_ssi")
      end
    end

  end
end
