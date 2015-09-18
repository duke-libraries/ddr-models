module Ddr::Models
  RSpec.describe EffectiveLicense do

    subject { described_class.call(obj) }

    let(:mock) { Struct.new(:license, :parent, :admin_policy, :pid) }
    let(:obj) { mock.new }

    let(:url) { "https://creativecommons.org/licenses/by-nc-nd/4.0/" }

    let(:license) { License.new(url: url) }
    before { allow(License).to receive(:find).with(url: url) { license } }

    describe "when the object has a license" do
      before { obj.license = url }
      it { is_expected.to eq(license) }
    end

    describe "when the object does not have a license" do
      describe "when the object has a parent" do
        let(:parent) { mock.new }
        before do
          parent.license = url
          obj.parent = parent
        end
        it { is_expected.to eq(license) }
      end
      describe "when the object does not have a parent" do
        describe "when the object has an admin policy" do
          describe "and the admin policy is a different object" do
            let(:admin_policy) { mock.new }
            before do
              admin_policy.license = url
              obj.admin_policy = admin_policy
            end
            it { is_expected.to eq(license) }
          end
          describe "and the admin policy is the object itself" do
            before { obj.admin_policy = obj }
            it { is_expected.to be_nil }
          end
        end
        describe "otherwise" do
          it { is_expected.to be_nil }
        end
      end
    end

  end
end
