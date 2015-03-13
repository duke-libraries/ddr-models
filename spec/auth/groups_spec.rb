module Ddr
  module Auth
    RSpec.describe Groups do 

      describe "instance methods" do

        subject { described_class.new(user, env) }

        let(:user) { FactoryGirl.build(:user) }

        describe "when the user is not persisted" do
          let(:env) { {} }
          it { is_expected.to eq([ Groups::Public ]) }
        end

        describe "when the user is persisted" do
          let(:env) { {} }

          before { allow(user).to receive(:persisted?) { true } }

          it { is_expected.to include(Groups::Public, Groups::Registered) }

          describe "when env is nil" do
            let(:env) { nil }
            it "should use Grouper to get remote groups" do
              expect_any_instance_of(Ddr::Auth.grouper_gateway).to receive(:user_group_names).with(user) do
                ["duke:library:repository:ddr:foo", "duke:library:repository:ddr:bar"] 
              end
              expect(subject).to include(Group.build("duke:library:repository:ddr:foo"), Group.build("duke:library:repository:ddr:bar"))
            end
            it "should use LDAP to get affiliations" do
              expect_any_instance_of(Ddr::Auth.ldap_gateway).to receive(:affiliations).with(user.principal_name) { ["faculty", "staff"] }
              expect(subject).to include(Affiliation.group("faculty"), Affiliation.group("staff"))
            end
            describe "and the user has a Duke principal name" do
              it "should include the Duke EPPN group" do
                expect(user).to receive(:principal_name).at_least(:once) { "foobar@duke.edu" }
                expect(subject).to include(Groups::DukeEppn) 
              end
            end
            describe "and the user does not have a Duke principal name" do
              it "should not include the Duke EPPN group" do
                expect(user).to receive(:principal_name).at_least(:once) { "foobar@unc.edu" }
                expect(subject).not_to include(Groups::DukeEppn) 
              end
            end
          end

          describe "when env lacks ismemberof, affiliation and eppn keys" do
            let(:env) { {} }
            it "should use Grouper to get remote groups" do
              expect_any_instance_of(Ddr::Auth.grouper_gateway).to receive(:user_group_names).with(user) do
                ["duke:library:repository:ddr:foo", "duke:library:repository:ddr:bar"] 
              end
              expect(subject).to include(Group.build("duke:library:repository:ddr:foo"), Group.build("duke:library:repository:ddr:bar"))
            end
            it "should use LDAP to get affiliations" do
              expect_any_instance_of(Ddr::Auth.ldap_gateway).to receive(:affiliations).with(user.principal_name) { ["faculty", "staff"] }
              expect(subject).to include(Affiliation.group("faculty"), Affiliation.group("staff"))
            end
            describe "and the user has a Duke principal name" do
              it "should include the Duke EPPN group" do
                expect(user).to receive(:principal_name).at_least(:once) { "foobar@duke.edu" }
                expect(subject).to include(Groups::DukeEppn) 
              end
            end
            describe "and the user does not have a Duke principal name" do
              it "should not include the Duke EPPN group" do
                expect(user).to receive(:principal_name).at_least(:once) { "foobar@unc.edu" }
                expect(subject).not_to include(Groups::DukeEppn) 
              end
            end
          end

          describe "when env has ismemberof, affiliation, and eppn keys" do
            let(:env) do
              {
                "ismemberof" => "urn:mace:duke.edu:groups:library:repository:ddr:foo;urn:mace:duke.edu:groups:library:repository:ddr:bar",
                "affiliation" => "faculty@duke.edu;staff@duke.edu"
              } 
            end
            it "should use the env to get remote groups" do
              expect_any_instance_of(Ddr::Auth.grouper_gateway).not_to receive(:user_group_names)
              expect(subject).to include(Group.build("duke:library:repository:ddr:foo"), Group.build("duke:library:repository:ddr:bar"))
            end
            it "should use the env to get affiliations" do
              expect_any_instance_of(Ddr::Auth.ldap_gateway).not_to receive(:affiliations)
              expect(subject).to include(Affiliation.group("faculty"), Affiliation.group("staff"))
            end
            describe "and the user has a Duke principal name" do
              before { env["eppn"] = "foobar@duke.edu" }
              it "should include the Duke EPPN group" do
                expect(user).not_to receive(:principal_name)
                expect(subject).to include(Groups::DukeEppn) 
              end
            end
            describe "and the user does not have a Duke principal name" do
              before { env["eppn"] = "foobar@unc.edu" }
              it "should not include the Duke EPPN group" do
                expect(user).not_to receive(:principal_name)
                expect(subject).not_to include(Groups::DukeEppn) 
              end
            end
          end
        end
      end

      describe "class methods" do
        describe ".all" do
          it "should include rmeote groups" do
            expect(described_class).to receive(:remote) { [Group.build("remote")] }
            expect(described_class.all).to include(Group.build("remote"))
          end
          it "should include affiliation groups" do
            expect(described_class.all).to include(*(Affiliation.groups))
          end
          it "should include the public group" do
            expect(described_class.all).to include(Groups::Public)
          end
          it "should include the registered group" do
            expect(described_class.all).to include(Groups::Registered)
          end
          it "should include the Duke EPPN group" do
            expect(described_class.all).to include(Groups::DukeEppn)
          end
        end

      end

    end
  end
end
