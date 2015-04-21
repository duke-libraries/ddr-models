module Ddr::Auth
  module Roles
    RSpec.describe RoleType do

      subject { described_class.new("Role Type", "Role Description", [:read, :write]) }

      it { is_expected.to be_frozen }
      its(:title) { is_expected.to eq("Role Type") }
      its(:label) { is_expected.to eq("Role Type") }
      its(:to_s) { is_expected.to eq("Role Type") }
      its(:description) { is_expected.to eq("Role Description") }
      its(:permissions) { is_expected.to eq([:read, :write]) }
      its(:permissions) { is_expected.to be_frozen }

    end
  end
end
