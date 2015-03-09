module Ddr
  module Auth
    RSpec.describe RemoteGroupService do

      subject { described_class.new(env) }

      describe "affiliation_groups" do
        let(:env) { {"affiliation" => "faculty@duke.edu;staff@duke.edu"} }
        it "should return the groups for the affiliations" do
          expect(subject.affiliation_groups).to match_array(["duke.faculty", "duke.staff"])
        end
      end

    end
  end
end
