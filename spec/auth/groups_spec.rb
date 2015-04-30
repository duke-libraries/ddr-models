module Ddr
  module Auth
    RSpec.describe Groups do

      describe "instance methods" do
        subject { described_class.new(groups) }
        describe "#agents" do
          let(:groups) { [Group.new("foo"), Group.new("bar"), Group.new("baz")] }
          its(:agents) { is_expected.to contain_exactly("foo", "bar", "baz") }
        end
      end

      describe "class methods" do
        describe ".all" do
          before do
            allow(described_class).to receive(:remote) { ["foo:bar:baz", "spam:eggs:hash"] }
          end
          subject { described_class.all }
          it { is_expected.to include(*(Affiliation.groups)) }
          it { is_expected.to include(Groups::PUBLIC) }
          it { is_expected.to include(Groups::REGISTERED) }
          it { is_expected.to include(Groups::DUKE_EPPN) }
          it { is_expected.to include(Group.new("foo:bar:baz"), Group.new("spam:eggs:hash")) }
        end

        describe ".build" do
          subject { described_class.build(user, env) }
          let(:user) { FactoryGirl.build(:user) }

          describe "when the user is not persisted" do
            let(:env) { {} }
            it { is_expected.to eq([ Groups::PUBLIC ]) }
          end

          describe "when the user is persisted" do
            let(:env) { {} }
            before { allow(user).to receive(:persisted?) { true } }
            it { is_expected.to include(Groups::PUBLIC, Groups::REGISTERED) }

            describe "when env is nil" do
              let(:env) { nil }
              it "should use Grouper to get remote groups" do
                groups = [Group.new("duke:library:repository:ddr:foo"), Group.new("duke:library:repository:ddr:bar")]
                expect_any_instance_of(Ddr::Auth.grouper_gateway).to receive(:user_groups).with(user) { groups }
                expect(subject).to include(*groups)
              end
              it "should use LDAP to get affiliations" do
                expect_any_instance_of(Ddr::Auth.ldap_gateway).to receive(:affiliations).with(user.principal_name) { ["faculty", "staff"] }
                expect(subject).to include(Affiliation.group("faculty"), Affiliation.group("staff"))
              end
              describe "and the user has a Duke principal name" do
                it "should include the Duke EPPN group" do
                  expect(user).to receive(:principal_name).at_least(:once) { "foobar@duke.edu" }
                  expect(subject).to include(Groups::DUKE_EPPN)
                end
              end
              describe "and the user does not have a Duke principal name" do
                it "should not include the Duke EPPN group" do
                  expect(user).to receive(:principal_name).at_least(:once) { "foobar@unc.edu" }
                  expect(subject).not_to include(Groups::DUKE_EPPN)
                end
              end
            end

            describe "when env lacks ismemberof, affiliation and eppn keys" do
              let(:env) { {} }
              it "should use Grouper to get remote groups" do
                groups = [Group.new("duke:library:repository:ddr:foo"), Group.new("duke:library:repository:ddr:bar")]
                expect_any_instance_of(Ddr::Auth.grouper_gateway).to receive(:user_groups).with(user) { groups }
                expect(subject).to include(*groups)
              end
              it "should use LDAP to get affiliations" do
                expect_any_instance_of(Ddr::Auth.ldap_gateway).to receive(:affiliations).with(user.principal_name) { ["faculty", "staff"] }
                expect(subject).to include(Affiliation.group("faculty"), Affiliation.group("staff"))
              end
              describe "and the user has a Duke principal name" do
                it "should include the Duke EPPN group" do
                  expect(user).to receive(:principal_name).at_least(:once) { "foobar@duke.edu" }
                  expect(subject).to include(Groups::DUKE_EPPN)
                end
              end
              describe "and the user does not have a Duke principal name" do
                it "should not include the Duke EPPN group" do
                  expect(user).to receive(:principal_name).at_least(:once) { "foobar@unc.edu" }
                  expect(subject).not_to include(Groups::DUKE_EPPN)
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
                expect(subject).to include(Group.new("duke:library:repository:ddr:foo"), Group.new("duke:library:repository:ddr:bar"))
              end
              it "should use the env to get affiliations" do
                expect_any_instance_of(Ddr::Auth.ldap_gateway).not_to receive(:affiliations)
                expect(subject).to include(Affiliation.group("faculty"), Affiliation.group("staff"))
              end
              describe "and the user has a Duke principal name" do
                before { env["eppn"] = "foobar@duke.edu" }
                it "should include the Duke EPPN group" do
                  expect(user).not_to receive(:principal_name)
                  expect(subject).to include(Groups::DUKE_EPPN)
                end
              end
              describe "and the user does not have a Duke principal name" do
                before { env["eppn"] = "foobar@unc.edu" }
                it "should not include the Duke EPPN group" do
                  expect(user).not_to receive(:principal_name)
                  expect(subject).not_to include(Groups::DUKE_EPPN)
                end
              end
            end
          end
        end
      end
    end
  end
end
