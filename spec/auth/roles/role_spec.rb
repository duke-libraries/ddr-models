module Ddr::Auth
  module Roles
    RSpec.describe Role do
      
      let(:agent) { "bob@example.com" }

      describe "default scope" do
        it "should be 'resource'" do
          expect(described_class.build(type: "Curator", agent: agent).scope.first).to eq("resource")          
        end
      end

      describe "validation" do
        it "should require the presence of an agent" do
          expect { described_class.build(type: "Curator", scope: "resource") }.to raise_error
          expect { described_class.build(type: "Curator", agent: nil, scope: "resource") }.to raise_error
          expect { described_class.build(type: "Curator", agent: "", scope: "resource") }.to raise_error
        end
        it "should require a valid scope" do
          expect { described_class.build(type: "Curator", agent: agent, scope: nil) }.to raise_error
          expect { described_class.build(type: "Curator", agent: agent, scope: "") }.to raise_error
          expect { described_class.build(type: "Curator", agent: agent, scope: "other") }.to raise_error
        end
        it "should require a valid type" do
          expect { described_class.build(agent: agent, scope: "policy") }.to raise_error
          expect { described_class.build(type: nil, agent: agent, scope: "policy") }.to raise_error
          expect { described_class.build(type: "", agent: agent, scope: "policy") }.to raise_error
          expect { described_class.build(type: "Invalid", agent: agent, scope: "policy") }.to raise_error
        end
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
              its(:to_h) { is_expected.to eq({type: type, agent: agent, scope: scope}) }
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
