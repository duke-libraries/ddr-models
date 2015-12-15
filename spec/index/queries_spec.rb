module Ddr::Index
  RSpec.describe Queries do

    describe "module methods" do
      let(:obj) { FactoryGirl.create(:item) }

      describe ".id" do
        specify {
          expect(Queries.id(obj.pid).pids.to_a).to eq [obj.pid]
        }
      end

      describe ".object" do
        specify {
          expect(Queries.object(obj).pids.to_a).to eq [obj.pid]
        }
      end
    end

  end
end
