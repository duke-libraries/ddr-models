module Ddr::Auth
  RSpec.describe Groups do

    describe ".call" do
      subject { Groups.call(auth_context) }

      describe "anonymous" do
        let(:auth_context) { FactoryGirl.build(:auth_context, :anonymous) }
        it { should include(Groups::PUBLIC) }
        it { should_not include(Groups::REGISTERED) }
        it { should_not include(Groups::DUKE_ALL) }
        it { should_not include(Groups::SUPERUSERS) }
        it { should_not include(Groups::COLLECTION_CREATORS) }
        it "should not include affiliation groups" do
          expect(subject.any? { |g| AffiliationGroups::ALL.include?(g) }).to be false
        end
      end

      describe "authenticated (not Duke)" do
        let(:auth_context) { FactoryGirl.build(:auth_context) }
        it { should include(Groups::PUBLIC) }
        it { should include(Groups::REGISTERED) }
        it { should_not include(Groups::DUKE_ALL) }
        it { should_not include(Groups::SUPERUSERS) }
        it { should_not include(Groups::COLLECTION_CREATORS) }
        it "should not include affiliation groups" do
          expect(subject.any? { |g| AffiliationGroups::ALL.include?(g) }).to be false
        end
      end

      describe "authenticated (Duke)" do
        let(:auth_context) { FactoryGirl.build(:auth_context, :duke) }
        it { should include(Groups::PUBLIC) }
        it { should include(Groups::REGISTERED) }
        it { should include(Groups::DUKE_ALL) }
        it { should_not include(Groups::SUPERUSERS) }
        it { should_not include(Groups::COLLECTION_CREATORS) }

        describe "with affiliations" do
          before do
            allow(auth_context).to receive(:affiliation) do
              [ Affiliation::STAFF, Affiliation::STUDENT ]
            end
          end
          it { should include(AffiliationGroups::STAFF) }
          it { should include(AffiliationGroups::STUDENT) }
          it { should_not include(AffiliationGroups::FACULTY) }
          it { should_not include(AffiliationGroups::AFFILIATE) }
          it { should_not include(AffiliationGroups::ALUMNI) }
          it { should_not include(AffiliationGroups::EMERITUS) }
        end

        describe "with remote groups" do
          before do
            allow(auth_context).to receive(:ismemberof) do
              [ "duke:foo:bar", "duke:spam:eggs" ]
            end
          end
          it { should include(Group.new("duke:foo:bar")) }
          it { should include(Group.new("duke:spam:eggs")) }
        end
      end

      describe "superusers" do
        let(:auth_context) { FactoryGirl.build(:auth_context) }
        before do
          allow(Ddr::Auth).to receive(:superuser_group) { "superusers" }
          allow(auth_context).to receive(:ismemberof) { [ Ddr::Auth.superuser_group ] }
        end
        it { should include(Groups::SUPERUSERS) }
      end

      describe "collection creators" do
        let(:auth_context) { FactoryGirl.build(:auth_context) }
        before do
          allow(Ddr::Auth).to receive(:collection_creators_group) { "collection_creators" }
          allow(auth_context).to receive(:ismemberof) { [ Ddr::Auth.collection_creators_group ] }
        end
        it { should include(Groups::COLLECTION_CREATORS) }
      end

    end


  end
end
