module Ddr
  module Auth
    RSpec.describe Groups, type: :model do 

      describe "instance methods" do

        subject { described_class.new(user, env) }

        describe "when the user is not persisted" do
          let(:env) { {} }
          let(:user) { FactoryGirl.build(:user) }
          it { is_expected.to be_empty }
        end

        describe "when the user is persisted" do
          let(:user) { FactoryGirl.create(:user) }

          describe "#remote_groups" do
            describe "when env is nil" do
              let(:env) { nil }
              before do
                allow(subject.grouper).to receive(:user_group_names).with(user) do
                  ["duke:library:repository:ddr:foo", "duke:library:repository:ddr:bar"] 
                end
              end
              it "should use Grouper" do
                expect(subject.remote_groups).to match_array(["duke:library:repository:ddr:foo", "duke:library:repository:ddr:bar"])
              end
            end
            describe "when env is present" do
              let(:env) { {"ismemberof" => "urn:mace:duke.edu:groups:library:repository:ddr:foo;urn:mace:duke.edu:groups:library:repository:ddr:bar"} }
              it "should use the env" do
                expect(subject.remote_groups).to match_array(["duke:library:repository:ddr:foo", "duke:library:repository:ddr:bar"])
              end
            end
          end

          describe "#affiliation_groups" do
            describe "when env is nil" do
              let(:env) { nil }
              before do
                allow(subject.ldap).to receive(:affiliations).with(user.principal_name) { ["faculty", "staff"] }
              end
              it "should use LDAP" do
                expect(subject.affiliation_groups).to match_array(["duke.faculty", "duke.staff"])
              end
            end
            describe "when env is present" do
              let(:env) { {"affiliation" => "faculty@duke.edu;staff@duke.edu"} }
              it "should use the env" do
                expect(subject.affiliation_groups).to match_array(["duke.faculty", "duke.staff"])
              end
            end
          end

          describe "#duke_netid?" do
            describe "when env is nil" do
              let(:env) { nil }
              describe "and the user has a Duke principal name" do
                before { allow(user).to receive(:principal_name) { "foobar@duke.edu" } }
                it "should be true" do
                  expect(subject.duke_netid?).to be true
                end
              end
              describe "and the user does not have a Duke principal name" do
                before { allow(user).to receive(:principal_name) { "foobar@unc.edu" } }
                it "should be false" do
                  expect(subject.duke_netid?).to be false
                end
              end
            end
          end

        end

      end

      describe "class methods" do
        subject { described_class }

        describe ".repository_groups" do
          it "should delegate to the grouper gateway" do
            expect_any_instance_of(Ddr::Auth.grouper_gateway).to receive(:repository_group_names)
            subject.repository_groups
          end
        end

        describe ".affiliation_groups" do
          it "should include all Duke affiliations" do
            expect(subject.affiliation_groups).to match_array(["duke.faculty", "duke.staff", "duke.student", "duke.affiliate", "duke.alumni", "duke.emeritus"])
          end
        end

        describe ".hydra_groups" do
          it "should include 'public' and 'registered'" do
            expect(subject.hydra_groups).to match_array(["public", "registered"])
          end
        end

        describe ".duke_netid_group" do
          it "should be 'duke.all'" do
            expect(subject.duke_netid_group).to eq("duke.all")
          end
        end

      end

    end
  end
end
