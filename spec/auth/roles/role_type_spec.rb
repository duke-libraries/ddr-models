module Ddr::Auth
  module Roles
    RSpec.describe RoleType do

      subject { described_class.new("Role Type", "Role Description", [:read, :write]) }

      it { should be_frozen }
      its(:title) { should eq("Role Type") }
      its(:title) { should be_frozen }
      its(:label) { should eq("Role Type") }
      its(:to_s) { should eq("Role Type") }
      its(:description) { should eq("Role Description") }
      its(:description) { should be_frozen }
      its(:permissions) { should eq([:read, :write]) }
      its(:permissions) { should be_frozen }

    end
  end
end
