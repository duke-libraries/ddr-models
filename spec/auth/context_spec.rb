module Ddr::Auth
  RSpec.describe Context do

    subject { described_class.new(env) }

    let(:env) do
      { "affiliation"=>"staff@duke.edu;student@duke.edu",
        "ismemberof"=>"group1;group2;group3"
      }
    end

    its(:affiliation) { should contain_exactly("staff@duke.edu", "student@duke.edu") }
    its(:ismemberof) { should contain_exactly("group1", "group2", "group3") }
    its(:groups) { should contain_exactly(Group.new("group1"), Group.new("group2"), Group.new("group3")) }
    
  end
end
