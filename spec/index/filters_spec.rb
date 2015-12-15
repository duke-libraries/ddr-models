module Ddr::Index
  RSpec.describe Filters do

    describe "class methods" do
      describe ".is_governed_by" do
        describe "with an object" do
          subject { Filters.is_governed_by(Item.new(pid: "test:1")) }
          its(:clauses) { is_expected.to eq(["{!term f=is_governed_by_ssim}info:fedora/test:1"]) }
        end
        describe "with an ID" do
          subject { Filters.is_governed_by("test:1") }
          its(:clauses) { is_expected.to eq(["{!term f=is_governed_by_ssim}info:fedora/test:1"]) }
        end
      end

      describe ".is_member_of_collection" do
        describe "with an object" do
          subject { Filters.is_member_of_collection(Item.new(pid: "test:1")) }
          its(:clauses) { is_expected.to eq(["{!term f=is_member_of_collection_ssim}info:fedora/test:1"]) }
        end
        describe "with an ID" do
          subject { Filters.is_member_of_collection("test:1") }
          its(:clauses) { is_expected.to eq(["{!term f=is_member_of_collection_ssim}info:fedora/test:1"]) }
        end
      end

      describe ".has_content" do
        subject { Filters.has_content }
        its(:clauses) { is_expected.to eq(["active_fedora_model_ssi:(Component OR Attachment OR Target)"]) }
      end
    end

  end
end
