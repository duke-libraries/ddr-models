module Ddr::Auth::Roles
  RSpec.describe Downloader do

    it_behaves_like "a role" do
      let(:role_type) { :downloader }
      let(:type) { Ddr::Vocab::Roles.Downloader }
      let(:permissions) { [:read, :download] }
    end

  end
end
