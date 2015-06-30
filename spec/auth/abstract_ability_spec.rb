module Ddr::Auth
  RSpec.describe AbstractAbility do

    subject { described_class.new(auth_context) }

    let(:auth_context) { FactoryGirl.build(:auth_context) }

    describe "default aliases from CanCan" do
      it "should have :create aliases" do
        expect(subject.aliased_actions[:create]).to contain_exactly(:new)
      end
      it "should have :read aliases" do
        expect(subject.aliased_actions[:read]).to contain_exactly(:index, :show)
      end
      it "should have :update aliases" do
        expect(subject.aliased_actions[:update]).to contain_exactly(:edit)
      end
    end

    describe "ability definitions" do
      let(:mock) do
        Class.new(AbilityDefinitions) do |klass|
          def call; end
        end
      end
      before do
        allow_any_instance_of(described_class).to receive(:ability_definitions) do
          [ mock ]
        end
      end
      it "should send :call" do
        expect(mock).to receive(:call)
        described_class.new(auth_context)
      end
    end

  end
end
