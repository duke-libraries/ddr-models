module Ddr::Models
  RSpec.describe Indexing do

    let(:obj) { FactoryGirl.build(:item) }

    subject { obj.index_fields }

    describe "legacy license fields" do
      before do
        obj.rightsMetadata.license.title = ["License Title"]
        obj.rightsMetadata.license.description = ["License Description"]
        obj.rightsMetadata.license.url = ["http://library.duke.edu"]
      end
      it { is_expected.to include(Ddr::Index::Fields::LICENSE_TITLE => "License Title") }
      it { is_expected.to include(Ddr::Index::Fields::LICENSE_DESCRIPTION => "License Description") }
      it { is_expected.to include(Ddr::IndexFields::LICENSE_URL => "http://library.duke.edu") }
    end

  end
end
