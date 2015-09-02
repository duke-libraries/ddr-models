module Ddr::Models
  RSpec.describe EffectiveLicense do

    subject { described_class.call(obj) }

    let(:mock) { Struct.new(:license, :parent, :admin_policy) }
    let(:obj) { mock.new }

    let(:code) { "cc-by-nc-40" }
    let(:license) { Ddr::Models::License.new(code: code) }
    before { allow(Ddr::Models::License).to receive(:get).with(code) { license } }

    describe "when the object has a licence code" do
      before { obj.license = code }
      it { is_expected.to eq(license) }
    end

    describe "when the object does not have a license" do
      describe "when the object has a parent" do
        let(:parent) { mock.new }
        before do
          parent.license = code
          obj.parent = parent
        end
        it { is_expected.to eq(license) }
      end
      describe "when the object does not have a parent" do
        describe "when the object has an admin policy" do
          describe "and the admin policy is a different object" do
            let(:admin_policy) { mock.new }
            before do
              admin_policy.license = code
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
