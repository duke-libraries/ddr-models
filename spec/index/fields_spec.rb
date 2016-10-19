module Ddr::Index
  RSpec.describe Fields do

    describe "module methods" do
      specify {
        expect(Fields.techmd).to contain_exactly(
                                   Fields::TECHMD_COLOR_SPACE,
                                   Fields::TECHMD_CREATING_APPLICATION,
                                   Fields::TECHMD_CREATION_TIME,
                                   Fields::TECHMD_FILE_SIZE,
                                   Fields::TECHMD_FITS_VERSION,
                                   Fields::TECHMD_FITS_DATETIME,
                                   Fields::TECHMD_FORMAT_LABEL,
                                   Fields::TECHMD_FORMAT_VERSION,
                                   Fields::TECHMD_ICC_PROFILE_NAME,
                                   Fields::TECHMD_ICC_PROFILE_VERSION,
                                   Fields::TECHMD_IMAGE_HEIGHT,
                                   Fields::TECHMD_IMAGE_WIDTH,
                                   Fields::TECHMD_MEDIA_TYPE,
                                   Fields::TECHMD_MODIFICATION_TIME,
                                   Fields::TECHMD_PRONOM_IDENTIFIER,
                                   Fields::TECHMD_VALID,
                                   Fields::TECHMD_WELL_FORMED
                                 )
      }
    end

    describe "constants" do
      describe "ID" do
        subject { Fields::ID }
        its(:label) { is_expected.to eq "Fedora PID" }
        its(:heading) { is_expected.to eq "pid" }
      end

      describe "PID" do
        subject { Fields::PID }
        its(:label) { is_expected.to eq "Fedora PID" }
        its(:heading) { is_expected.to eq "pid" }
      end

      describe "ACCESS_ROLE" do
        subject { Fields::ACCESS_ROLE }
        its(:label) { is_expected.to eq "Access Role" }
        its(:heading) { is_expected.to eq "access_role" }
      end

      describe "ACTIVE_FEDORA_MODEL" do
        subject { Fields::ACTIVE_FEDORA_MODEL }
        its(:label) { is_expected.to eq "Model" }
        its(:heading) { is_expected.to eq "model" }
      end

      describe "ADMIN_SET" do
        subject { Fields::ADMIN_SET }
        its(:label) { is_expected.to eq "Admin Set" }
        its(:heading) { is_expected.to eq "admin_set" }
      end

      describe "ASPACE_ID" do
        subject { Fields::ASPACE_ID }
        its(:label) { is_expected.to eq "ArchivesSpace ID" }
        its(:heading) { is_expected.to eq "aspace_id" }
      end

      describe "CATEGORY_FACET" do
        subject { Fields::CATEGORY_FACET }
        its(:label) { is_expected.to eq "Category Facet" }
        its(:heading) { is_expected.to eq "category_facet" }
      end

      describe "COMPANY_FACET" do
        subject { Fields::COMPANY_FACET }
        its(:label) { is_expected.to eq "Company Facet" }
        its(:heading) { is_expected.to eq "company_facet" }
      end

      describe "DOI" do
        subject { Fields::DOI }
        its(:label) { is_expected.to eq "DOI" }
        its(:heading) { is_expected.to eq "doi" }
      end

      describe "EAD_ID" do
        subject { Fields::EAD_ID }
        its(:label) { is_expected.to eq "EAD ID" }
        its(:heading) { is_expected.to eq "ead_id" }
      end

      describe "LOCAL_ID" do
        subject { Fields::LOCAL_ID }
        its(:label) { is_expected.to eq "Local ID" }
        its(:heading) { is_expected.to eq "local_id" }
      end

      describe "MEDIUM_FACET" do
        subject { Fields::MEDIUM_FACET }
        its(:label) { is_expected.to eq "Medium Facet" }
        its(:heading) { is_expected.to eq "medium_facet" }
      end

      describe "OBJECT_CREATE_DATE" do
        subject { Fields::OBJECT_CREATE_DATE }
        its(:label) { is_expected.to eq "Creation Date" }
        its(:heading) { is_expected.to eq "creation_date" }
      end

      describe "OBJECT_MODIFIED_DATE" do
        subject { Fields::OBJECT_MODIFIED_DATE }
        its(:label) { is_expected.to eq "Modification Date" }
        its(:heading) { is_expected.to eq "modification_date" }
      end

      describe "PERMANENT_ID" do
        subject { Fields::PERMANENT_ID }
        its(:label) { is_expected.to eq "Permanent ID" }
        its(:heading) { is_expected.to eq "permanent_id" }
      end

      describe "PERMANENT_URL" do
        subject { Fields::PERMANENT_URL }
        its(:label) { is_expected.to eq "Permanent URL" }
        its(:heading) { is_expected.to eq "permanent_url" }
      end

      describe "PLACEMENT_COMPANY_FACET" do
        subject { Fields::PLACEMENT_COMPANY_FACET }
        its(:label) { is_expected.to eq "Placement Company Facet" }
        its(:heading) { is_expected.to eq "placement_company_facet" }
      end

      describe "PRODUCT_FACET" do
        subject { Fields::PRODUCT_FACET }
        its(:label) { is_expected.to eq "Product Facet" }
        its(:heading) { is_expected.to eq "product_facet" }
      end

      describe "PUBLICATION_FACET" do
        subject { Fields::PUBLICATION_FACET }
        its(:label) { is_expected.to eq "Publication Facet" }
        its(:heading) { is_expected.to eq "publication_facet" }
      end

      describe "SETTING_FACET" do
        subject { Fields::SETTING_FACET }
        its(:label) { is_expected.to eq "Setting Facet" }
        its(:heading) { is_expected.to eq "setting_facet" }
      end

      describe "TECHMD_COLOR_SPACE" do
        subject { Fields::TECHMD_COLOR_SPACE }
        its(:label) { is_expected.to eq "Color Space" }
        its(:heading) { is_expected.to eq "color_space" }
      end

      describe "TECHMD_CREATING_APPLICATION" do
        subject { Fields::TECHMD_CREATING_APPLICATION }
        its(:label) { is_expected.to eq "Creating Application" }
        its(:heading) { is_expected.to eq "creating_application" }
      end

      describe "TECHMD_CREATION_TIME" do
        subject { Fields::TECHMD_CREATION_TIME }
        its(:label) { is_expected.to eq "Creation Time" }
        its(:heading) { is_expected.to eq "creation_time" }
      end

      describe "TECHMD_FILE_SIZE" do
        subject { Fields::TECHMD_FILE_SIZE }
        its(:label) { is_expected.to eq "File Size" }
        its(:heading) { is_expected.to eq "file_size" }
      end

      describe "TECHMD_FITS_VERSION" do
        subject { Fields::TECHMD_FITS_VERSION }
        its(:label) { is_expected.to eq "FITS Version" }
        its(:heading) { is_expected.to eq "fits_version" }
      end

      describe "TECHMD_FITS_DATETIME" do
        subject { Fields::TECHMD_FITS_DATETIME }
        its(:label) { is_expected.to eq "FITS Run At" }
        its(:heading) { is_expected.to eq "fits_datetime" }
      end

      describe "TECHMD_FORMAT_LABEL" do
        subject { Fields::TECHMD_FORMAT_LABEL }
        its(:label) { is_expected.to eq "Format Label" }
        its(:heading) { is_expected.to eq "format_label" }
      end

      describe "TECHMD_FORMAT_VERSION" do
        subject { Fields::TECHMD_FORMAT_VERSION }
        its(:label) { is_expected.to eq "Format Version" }
        its(:heading) { is_expected.to eq "format_version" }
      end

      describe "TECHMD_IMAGE_HEIGHT" do
        subject { Fields::TECHMD_IMAGE_HEIGHT }
        its(:label) { is_expected.to eq "Image Height" }
        its(:heading) { is_expected.to eq "image_height" }
      end

      describe "TECHMD_IMAGE_WIDTH" do
        subject { Fields::TECHMD_IMAGE_WIDTH }
        its(:label) { is_expected.to eq "Image Width" }
        its(:heading) { is_expected.to eq "image_width" }
      end

      describe "TECHMD_MEDIA_TYPE" do
        subject { Fields::TECHMD_MEDIA_TYPE }
        its(:label) { is_expected.to eq "Media Type" }
        its(:heading) { is_expected.to eq "media_type" }
      end

      describe "TECHMD_MODIFICATION_TIME" do
        subject { Fields::TECHMD_MODIFICATION_TIME }
        its(:label) { is_expected.to eq "Modification Time" }
        its(:heading) { is_expected.to eq "modification_time" }
      end

      describe "TECHMD_PRONOM_IDENTIFIER" do
        subject { Fields::TECHMD_PRONOM_IDENTIFIER }
        its(:label) { is_expected.to eq "PRONOM Unique ID" }
        its(:heading) { is_expected.to eq "pronom_uid" }
      end

      describe "TECHMD_VALID" do
        subject { Fields::TECHMD_VALID }
        its(:label) { is_expected.to eq "Valid" }
        its(:heading) { is_expected.to eq "valid" }
      end

      describe "TECHMD_WELL_FORMED" do
        subject { Fields::TECHMD_WELL_FORMED }
        its(:label) { is_expected.to eq "Well-formed" }
        its(:heading) { is_expected.to eq "well_formed" }
      end

      describe "TONE_FACET" do
        subject { Fields::TONE_FACET }
        its(:label) { is_expected.to eq "Tone Facet" }
        its(:heading) { is_expected.to eq "tone_facet" }
      end
    end

  end
end
