module Ddr::Auth
  RSpec.describe RoleSet do

    describe "JSON serialization / deserialization" do
      subject { described_class.new roles: [role1, role2] }

      let(:role1) { {role_type: "Editor", agent: "bob@example.com", scope: "resource"} }
      let(:role2) { {role_type: "Curator", agent: "sue@example.com", scope: "policy"} }
      let(:json) { "{\"roles\":[{\"agent\":\"bob@example.com\",\"role_type\":\"Editor\",\"scope\":\"resource\"},{\"agent\":\"sue@example.com\",\"role_type\":\"Curator\",\"scope\":\"policy\"}]}" }

      its(:to_json) { is_expected.to eq(json) }
      it "loads data from JSON" do
        expect(described_class.from_json(json).roles).to eq(Set.new([Role.new(role1), Role.new(role2)]))
      end
    end

    describe "conversion to array" do
      subject { described_class.new roles: roles }

      let(:roles) { FactoryGirl.build_list(:role, 3, :contributor, :person, :resource) }

      its(:to_a) { is_expected.to be_a(Array) }
      it { is_expected.to contain_exactly(*roles) }
    end

    describe "equality" do
      subject { described_class.new roles: [role1, role2] }

      let(:role1) { FactoryGirl.build(:role, :curator, :person, :policy) }
      let(:role2) { FactoryGirl.build(:role, :editor, :group, :resource) }
      let(:other) { described_class.new roles: [role2, role1] }

      it "is equal to another role set if it has the same roles, regardless of order" do
        expect(subject).to eq(other)
      end
    end

    describe "delegated methods" do
      let(:role1) { FactoryGirl.build(:role, :curator, :person, :policy) }

      specify {
        expect { subject << role1 }.to change { subject.roles.to_a }.from([]).to([role1])
      }
    end

  end
end
