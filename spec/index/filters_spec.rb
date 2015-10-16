module Ddr::Index
  RSpec.describe Filters do

    describe "HAS_CONTENT" do
      subject { Filters::HAS_CONTENT }
      its(:clauses) { is_expected.to eq(["active_fedora_model_ssi:(Component OR Attachment OR Target)"]) }
    end

    describe "class methods" do
      describe "is_governed_by(pid)" do
        subject { Filters.is_governed_by("test-1") }
        its(:clauses) { is_expected.to eq(["{!term f=is_governed_by_ssim}test-1"]) }
      end
    end

  end
end
