module Ddr::Auth
  module Roles
    RSpec.describe Role do

      describe "scope" do
        describe "default scope" do
          subject { described_class.new(role_type: "Curator", agent: "bob") }
          its(:scope) { is_expected.to eq(described_class::DEFAULT_SCOPE) }
        end
        describe "#in_resource_scope?" do
          describe "when scope == 'resource'" do
            subject { described_class.new(role_type: "Curator", agent: "bob", scope: "resource") }
            it { is_expected.to be_in_resource_scope }
          end
          describe "when scope != 'resource'" do
            subject { described_class.new(role_type: "Curator", agent: "bob", scope: "policy") }
            it { is_expected.to_not be_in_resource_scope }
          end
        end
        describe "#in_policy_scope?" do
          describe "when scope != 'policy'" do
            subject { described_class.new(role_type: "Curator", agent: "bob", scope: "resource") }
            it { is_expected.to_not be_in_policy_scope }
          end
          describe "when scope == 'policy'" do
            subject { described_class.new(role_type: "Curator", agent: "bob", scope: "policy") }
            it { is_expected.to be_in_policy_scope }
          end
        end
      end

      describe "validation" do
        it "requires the presence of an agent" do
          expect { described_class.new(role_type: "Curator", scope: "resource") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.new(role_type: "Curator", agent: nil, scope: "resource") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.new(role_type: "Curator", agent: "", scope: "resource") }
            .to raise_error(Ddr::Models::Error)
        end
        it "requires a valid scope" do
          expect { described_class.new(role_type: "Curator", agent: "bob", scope: "") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.new(role_type: "Curator", agent: "bob", scope: "other") }
            .to raise_error(Ddr::Models::Error)
        end
        it "requires a valid type" do
          expect { described_class.new(agent: "bob", scope: "policy") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.new(role_type: nil, agent: "bob", scope: "policy") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.new(role_type: "", agent: "bob", scope: "policy") }
            .to raise_error(Ddr::Models::Error)
          expect { described_class.new(role_type: "Invalid", agent: "bob", scope: "policy") }
            .to raise_error(Ddr::Models::Error)
        end
      end

      describe "serialization / deserialization" do
        subject { FactoryGirl.build(:role, :curator, :person, :resource) }
        it { is_expected.to eq(described_class.from_json(subject.to_json)) }
      end

      describe "attribute value coercion" do
        subject { described_class.new(role_type: ["Curator"], agent: user, scope: :resource) }
        let(:user) { ::User.new(username: "bob") }
        its(:role_type) { is_expected.to eq("Curator") }
        its(:agent) { is_expected.to eq("bob") }
        its(:scope) { is_expected.to eq("resource") }
      end

      Roles.type_map.each_key do |type|
        describe "#{type} role type" do
          Roles::SCOPES.each do |scope|
            describe "#{scope} scope" do
              subject { described_class.new(role_type: type, agent: "bob", scope: scope) }
              it { is_expected.to be_valid }
              its(:to_h) { is_expected.to eq({role_type: type, agent: "bob", scope: scope}) }
              its(:permissions) { is_expected.to eq(Roles.type_map[type].permissions) }
              it "is a value object" do
                expect(subject).to eq(described_class.new(role_type: type, agent: "bob", scope: scope))
                expect(subject).to eql(described_class.new(role_type: type, agent: "bob", scope: scope))
              end
            end
          end
        end
      end

    end
  end
end
