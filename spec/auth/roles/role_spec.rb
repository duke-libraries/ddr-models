module Ddr::Auth
  module Roles
    RSpec.describe Role do

      let(:agent) { "bob@example.com" }

      describe "equality" do
        subject { described_class.build(role_type: "Viewer", agent: "public", scope: "policy") }
        describe "when two roles have the same type, agent and scope" do
          let(:other) { described_class.build(role_type: "Viewer", agent: "public", scope: "policy") }
          it { is_expected.to eq(other) }
          it { is_expected.to eql(other) }
        end
      end

      describe "scope" do
        describe "default scope" do
          subject { described_class.build(role_type: "Curator", agent: agent) }
          its(:scope) { is_expected.to eq(described_class::DEFAULT_SCOPE) }
        end
        describe "#in_resource_scope?" do
          describe "when scope == 'resource'" do
            subject { described_class.build(role_type: "Curator", agent: agent, scope: "resource") }
            it { is_expected.to be_in_resource_scope }
          end
          describe "when scope != 'resource'" do
            subject { described_class.build(role_type: "Curator", agent: agent, scope: "policy") }
            it { is_expected.to_not be_in_resource_scope }
          end
        end
        describe "#in_policy_scope?" do
          describe "when scope != 'policy'" do
            subject { described_class.build(role_type: "Curator", agent: agent, scope: "resource") }
            it { is_expected.to_not be_in_policy_scope }
          end
          describe "when scope == 'policy'" do
            subject { described_class.build(role_type: "Curator", agent: agent, scope: "policy") }
            it { is_expected.to be_in_policy_scope }
          end
        end
      end

      describe "validation" do
        it "requires the presence of an agent" do
          expect { described_class.build(role_type: "Curator", scope: "resource") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.build(role_type: "Curator", agent: nil, scope: "resource") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.build(role_type: "Curator", agent: "", scope: "resource") }
            .to raise_error(Ddr::Models::Error)
        end
        it "requires a valid scope" do
          expect { described_class.build(role_type: "Curator", agent: agent, scope: "") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.build(role_type: "Curator", agent: agent, scope: "other") }
            .to raise_error(Ddr::Models::Error)
        end
        it "requires a valid type" do
          expect { described_class.build(agent: agent, scope: "policy") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.build(role_type: nil, agent: agent, scope: "policy") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.build(role_type: "", agent: agent, scope: "policy") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.build(role_type: "Invalid", agent: agent, scope: "policy") }
            .to raise_error(Ddr::Models::Error)
        end
      end

      describe "serialization / deserialization" do
        subject { FactoryGirl.build(:role, :curator, :person, :resource) }
        it { is_expected.to eq(described_class.from_json(subject.to_json)) }
      end

      Roles.type_map.each_key do |type|
        describe "#{type} role type" do
          Roles::SCOPES.each do |scope|
            describe "#{scope} scope" do
              subject { described_class.build(role_type: type, agent: agent, scope: scope) }
              it { is_expected.to be_valid }
              its(:role_type) { is_expected.to eq(type) }
              its(:agent) { is_expected.to eq(agent) }
              its(:scope) { is_expected.to eq(scope) }
              its(:to_h) { is_expected.to eq({role_type: type, agent: agent, scope: scope}) }
              its(:permissions) { is_expected.to eq(Roles.type_map[type].permissions) }
              it "is a value object" do
                expect(subject).to eq(described_class.build(role_type: type, agent: agent, scope: scope))
              end
            end
          end
        end
      end

    end
  end
end
