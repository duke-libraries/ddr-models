module Ddr::Models
  RSpec.describe EffectiveLicense do

    subject { described_class.call(obj) }

    let(:url) { "https://creativecommons.org/licenses/by-nc-nd/4.0/" }

    let(:license) { License.new(url: url) }
    before { allow(License).to receive(:find).with(url: url) { license } }

    let(:obj) { double(pid: "test:1", id: "test:1", license: nil, parent: nil, admin_policy: nil, admin_policy_id: nil) }

    describe "when the object has a license" do
      before { allow(obj).to receive(:license) { url } }
      it { is_expected.to eq(license) }
    end

    describe "when the object does not have a license" do
      describe "and the object has a parent" do
        let(:parent) { double(pid: "test:2", license: nil) }
        before do
          allow(obj).to receive(:parent) { parent }
        end
        describe "and the parent has a license" do
          before do
            allow(parent).to receive(:license) { url }
          end
          it { is_expected.to eq(license) }
        end
        describe "and the parent does not have a license" do
          it { is_expected.to be_nil }
        end
      end
      describe "and the object does not have a parent" do
        describe "and the object has an admin policy" do
          let(:admin_policy) { double(pid: "test:3", id: "test:3", license: nil) }
          before { allow(obj).to receive(:admin_policy) { admin_policy } }
          describe "and the admin policy has a different id from the object" do
            before do
              allow(obj).to receive(:admin_policy_id) { "test:3" }
            end
            describe "and the admin policy has a license" do
              before do
                allow(admin_policy).to receive(:license) { url }
              end
              it { is_expected.to eq(license) }
            end
            describe "and the admin policy does not have a license" do
              it { is_expected.to be_nil }
            end
          end
          describe "and the admin policy has the same id as the object" do
            before { allow(obj).to receive(:admin_policy_id) { obj.id } }
            it { is_expected.to be_nil }
          end
        end
        describe "and the object does not have an admin policy" do
          it { is_expected.to be_nil }
        end
      end
    end

  end
end
