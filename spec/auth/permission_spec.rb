module Ddr::Auth
  RSpec.describe Permission do

    describe "class methods" do
      describe ".all" do
        subject { described_class.all }
        it { is_expected.to match_array([described_class::Read, described_class::Download, described_class::Edit, described_class::AddChildren, described_class::Upload, described_class::Arrange, described_class::Grant]) }
      end
      describe ".get" do
        subject { described_class.get(:read) }
        it { is_expected.to eq(described_class::Read) }
      end
    end

    describe "constants" do
      describe "Read" do
        subject { described_class::Read }
        it { is_expected.to eq(described_class.get(:read)) }
        it { is_expected.to eq(:read) }
      end
      describe "Download" do 
        subject { described_class::Download }
        it { is_expected.to eq(described_class.get(:download)) }
        it { is_expected.to eq(:download) }
      end
      describe "Edit" do
        subject { described_class::Edit }
        it { is_expected.to eq(described_class.get(:edit)) }
        it { is_expected.to eq(:edit) }
      end
      describe "AddChildren" do
        subject { described_class::AddChildren }
        it { is_expected.to eq(described_class.get(:add_children)) }
        it { is_expected.to eq(:add_children) }
      end
      describe "Upload" do
        subject { described_class::Upload }
        it { is_expected.to eq(described_class.get(:upload)) }
        it { is_expected.to eq(:upload) }
      end
      describe "Arrange" do
        subject { described_class::Arrange }
        it { is_expected.to eq(described_class.get(:arrange)) }
        it { is_expected.to eq(:arrange) }
      end
      describe "Grant" do
        subject { described_class::Grant }
        it { is_expected.to eq(described_class.get(:grant)) }
        it { is_expected.to eq(:grant) }
      end
    end

  end
end
