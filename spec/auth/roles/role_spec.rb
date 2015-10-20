module Ddr::Auth
  module Roles
    RSpec.describe Role do

      let(:agent) { "bob@example.com" }

      describe "equality" do
        subject { described_class.build(type: "Viewer", agent: "public", scope: "policy") }
        describe "when two roles have the same type, agent and scope" do
          let(:other) { described_class.build(type: "Viewer", agent: "public", scope: "policy") }
          it { should eq(other) }
          it { should eql(other) }
        end
      end

      describe "scope" do
        describe "default scope" do
          subject { described_class.build(type: "Curator", agent: agent) }
          its(:scope) { should eq([described_class::DEFAULT_SCOPE]) }
        end
        describe "#in_resource_scope?" do
          describe "when scope == 'resource'" do
            subject { described_class.build(type: "Curator", agent: agent, scope: "resource") }
            it { should be_in_resource_scope }
          end
          describe "when scope != 'resource'" do
            subject { described_class.build(type: "Curator", agent: agent, scope: "policy") }
            it { should_not be_in_resource_scope }
          end
        end
        describe "#in_policy_scope?" do
          describe "when scope != 'policy'" do
            subject { described_class.build(type: "Curator", agent: agent, scope: "resource") }
            it { should_not be_in_policy_scope }
          end
          describe "when scope == 'policy'" do
            subject { described_class.build(type: "Curator", agent: agent, scope: "policy") }
            it { should be_in_policy_scope }
          end
        end
      end

      describe "validation" do
        it "should require the presence of an agent" do
          pending "https://github.com/projecthydra/active_fedora/issues/915"
          expect { described_class.build(type: "Curator", scope: "resource") }.to raise_error
          expect { described_class.build(type: "Curator", agent: nil, scope: "resource") }.to raise_error
          expect { described_class.build(type: "Curator", agent: "", scope: "resource") }.to raise_error
        end
        it "should require a valid scope" do
          pending "https://github.com/projecthydra/active_fedora/issues/915"
          expect { described_class.build(type: "Curator", agent: agent, scope: "") }.to raise_error
          expect { described_class.build(type: "Curator", agent: agent, scope: "other") }.to raise_error
        end
        it "should require a valid type" do
          pending "https://github.com/projecthydra/active_fedora/issues/915"
          expect { described_class.build(agent: agent, scope: "policy") }.to raise_error
          expect { described_class.build(type: nil, agent: agent, scope: "policy") }.to raise_error
          expect { described_class.build(type: "", agent: agent, scope: "policy") }.to raise_error
          expect { described_class.build(type: "Invalid", agent: agent, scope: "policy") }.to raise_error
        end
      end

      describe "serialization / deserialization" do
        subject { FactoryGirl.build(:role, :curator, :person, :resource) }
        it { should eq(described_class.deserialize(subject.serialize)) }
        it { should eq(described_class.from_json(subject.to_json)) }
      end

      Roles.type_map.each_key do |type|
        describe "#{type} role type" do
          Roles::SCOPES.each do |scope|
            describe "#{scope} scope" do
              subject { described_class.build(type: type, agent: agent, scope: scope) }
              it { is_expected.to be_valid }
              its(:role_type) { is_expected.to eq([type]) }
              its(:agent) { is_expected.to eq([agent]) }
              its(:scope) { is_expected.to eq([scope]) }
              its(:to_h) { is_expected.to eq({"role_type"=>[type], "agent"=>[agent], "scope"=>[scope]}) }
              its(:permissions) { is_expected.to eq(Roles.type_map[type].permissions) }
              it "should be isomorphic" do
                expect(subject).to eq(described_class.build(type: type, agent: agent, scope: scope))
              end
            end
          end
        end
      end

    end
  end
end
