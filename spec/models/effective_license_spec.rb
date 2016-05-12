module Ddr::Models
  RSpec.describe EffectiveLicense do

    subject { described_class.call(obj) }

    let(:url) { "https://creativecommons.org/licenses/by-nc-nd/4.0/" }

    let(:license) { License.new(url: url) }

    let(:obj) { Component.new(id: "test-1") }
    let(:parent) { Item.new(id: "test-2") }
    let(:admin_policy) { Collection.new(id: "test-3") }

    describe "when the object has a license" do
      before do
        allow(License).to receive(:call).with(obj) { license }
      end
      it { is_expected.to eq(license) }
    end

    describe "when the object does not have a license" do
      before do
        allow(License).to receive(:call).with(obj) { nil }
      end
      describe "and the object has a parent" do
        before do
          allow(obj).to receive(:parent) { parent }
        end
        describe "and the parent has a license" do
          before do
            allow(License).to receive(:call).with(parent) { license }
          end
          it { is_expected.to eq(license) }
        end
        describe "and the parent does not have a license" do
          before do
            allow(License).to receive(:call).with(parent) { nil }
          end
          it { is_expected.to be_nil }
        end
      end
      describe "and the object does not have a parent" do
        describe "and the object has an admin policy" do
          before { allow(obj).to receive(:admin_policy) { admin_policy } }
          describe "and the admin policy has a different id from the object" do
            before do
              allow(obj).to receive(:admin_policy_id) { "test-3" }
            end
            describe "and the admin policy has a license" do
              before do
                allow(License).to receive(:call).with(admin_policy) { license }
              end
              it { is_expected.to eq(license) }
            end
            describe "and the admin policy does not have a license" do
              before do
                allow(License).to receive(:call).with(admin_policy) { nil }
              end
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
