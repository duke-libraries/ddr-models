require 'spec_helper'
require 'cancan/matchers'

module Ddr
  module Auth
    RSpec.describe Ability, type: :model, abilities: true do

      subject { described_class.new(user) }
      let(:user) { FactoryGirl.create(:user) }

      describe "collection permissions" do
        before { allow(Ddr::Auth).to receive(:collection_creators_group) { "Collection Creators" } }
        context "user is a collection creator" do
          before { allow(user).to receive(:groups) { ["Collection Creators"] } }
          it { is_expected.to be_able_to(:create, Collection) }
        end
        context "user is not a collection creator" do
          it { is_expected.not_to be_able_to(:create, Collection) }
        end
      end

      describe "#upload_permissions", uploads: true do
        let(:resource) { FactoryGirl.build(:component) }
        context "user has edit permission" do
          before { subject.can(:edit, resource) }
          it { is_expected.to be_able_to(:upload, resource) }
        end
        context "user does not have edit permission" do
          before { subject.cannot(:edit, resource) }
          it { is_expected.not_to be_able_to(:upload, resource) }
        end
      end

      describe "#download_permissions", downloads: true do
        context "on an object" do
          context "which is a Component", components: true do
            let!(:resource) { FactoryGirl.create(:component) }
            context "and user does NOT have the downloader role" do
              context "and user has edit permission" do
                before do
                  resource.edit_users = [user.user_key]
                  resource.save
                end
                it { is_expected.to be_able_to(:download, resource) }
              end
              context "and user has read permission" do
                before do
                  resource.read_users = [user.user_key]
                  resource.save
                end
                it { is_expected.not_to be_able_to(:download, resource) }
              end
              context "and user lacks read permission" do
                it { is_expected.not_to be_able_to(:download, resource) }
              end
            end
            # Component
            context "and user has the downloader role", roles: true do
              before do
                resource.roles.downloader << user.principal_name
                resource.save
              end
              context "and user has edit permission" do
                before do
                  resource.edit_users = [user.user_key]
                  resource.save
                end
                it { is_expected.to be_able_to(:download, resource) }
              end
              context "and user has read permission" do
                before do
                  resource.read_users = [user.user_key]
                  resource.save
                end
                it { is_expected.to be_able_to(:download, resource) }
              end
              context "and user lacks read permission" do
                it { is_expected.not_to be_able_to(:download, resource) }
              end          
            end
          end

          context "which is not a Component" do
            let(:resource) { FactoryGirl.create(:test_content) }
            context "and user has read permission" do
              before do
                resource.read_users = [user.user_key]
                resource.save
              end
              it { is_expected.to be_able_to(:download, resource) }
            end
            context "and user lacks read permission" do
              it { is_expected.not_to be_able_to(:download, resource) }
            end                  
          end
        end

        context "on a Solr document" do
          let(:resource) { SolrDocument.new(doc) }
          context "for a Component" do
            let(:doc) { {'id'=>'test:1', 'active_fedora_model_ssi'=>'Component'} }
            context "on which the user has the downloader role" do
              before { doc.merge!('admin_metadata__downloader_ssim'=>[user.to_s]) }
              context "but does not have read permission" do
                it { is_expected.not_to be_able_to(:download, resource) }
              end
              context "and has read permission" do
                before { doc.merge!('read_access_person_ssim'=>[user.to_s]) }
                it { is_expected.to be_able_to(:download, resource) }
              end
              context "and has edit permission" do
                before { doc.merge!('edit_access_person_ssim'=>[user.to_s]) }
                it { is_expected.to be_able_to(:download, resource) }
              end
            end
            context "on which the user does NOT have the downloader role" do
              context "and does not have read permission" do
                it { is_expected.not_to be_able_to(:download, resource) }
              end
              context "but has read permission" do
                before { doc.merge!('read_access_person_ssim'=>[user.to_s]) }
                it { is_expected.not_to be_able_to(:download, resource) }
              end
              context "but has edit permission" do
                before { doc.merge!('edit_access_person_ssim'=>[user.to_s]) }
                it { is_expected.to be_able_to(:download, resource) }
              end              
            end
          end
          context "for a non-Component" do
            let(:doc) { {'id'=>'test:1', 'active_fedora_model_ssi'=>'Attachment'} }
            context "on which the user does NOT have read permission" do
              it { is_expected.not_to be_able_to(:download, resource) }
            end
            context "on which the user has read permission" do
              before { doc.merge!('read_access_person_ssim'=>[user.to_s]) }
              it { is_expected.to be_able_to(:download, resource) }
            end
            context "on which the user has edit permission" do
              before { doc.merge!('edit_access_person_ssim'=>[user.to_s]) }
              it { is_expected.to be_able_to(:download, resource) }
            end              
          end
        end

        context "on a datastream", datastreams: true do
          context "named 'content'", content: true do
            let(:resource) { obj.content }
            context "and object is a Component", components: true do
              let(:obj) { FactoryGirl.create(:component) }
              context "and user does not have the downloader role" do
                context "and user has read permission on the object" do
                  before do
                    obj.read_users = [user.user_key]
                    obj.save
                  end
                  it { is_expected.not_to be_able_to(:download, resource) }
                end
                context "and user lacks read permission on the object" do
                  it { is_expected.not_to be_able_to(:download, resource) }
                end
              end
              # Component content datastream
              context "and user has the downloader role", roles: true do
                before do
                  obj.roles.downloader << user.principal_name
                  obj.save
                end
                context "and user has read permission on the object" do
                  before do
                    obj.read_users = [user.user_key]
                    obj.save
                  end
                  it { is_expected.to be_able_to(:download, resource) }
                end
                context "and user lacks read permission on the object" do
                  it { is_expected.not_to be_able_to(:download, resource) }
                end          
              end
            end
            # non-Component content datastream
            context "and object is not a Component" do
              let(:obj) { FactoryGirl.create(:test_content) }
              context "and user has read permission on the object" do
                before do
                  obj.read_users = [user.user_key]
                  obj.save
                end
                it { is_expected.to be_able_to(:download, resource) }
              end
              context "and user lacks read permission on the object" do
                it { is_expected.not_to be_able_to(:download, resource) }
              end                  
            end

          end
          # datastream - not "content"
          context "not named 'content'" do
            let(:obj) { FactoryGirl.create(:test_model) }
            let(:resource) { obj.descMetadata }
            context "and user has read permission on the object" do
              before do
                obj.read_users = [user.user_key]
                obj.save
              end
              it { is_expected.to be_able_to(:download, resource) }
            end
            context "and user lacks read permission on the object" do
              it { is_expected.not_to be_able_to(:download, resource) }
            end        
          end

        end

      end # download_permissions

      describe "#discover_permissions" do
        # TODO
      end

      describe "#events_permissions", events: true do
        let(:object) { FactoryGirl.create(:test_model) }
        let(:resource) { Ddr::Events::Event.new(pid: object.pid) }
        context "event is associated with a user" do
          before { resource.user = user }
          it { is_expected.to be_able_to(:read, resource) }
        end
        context "event is not associated with a user" do      
          context "and can read object" do
            before do
              object.read_users = [user.user_key]
              object.save!
            end
            it { is_expected.to be_able_to(:read, resource) }
          end
          context "and cannot read object" do
            it { is_expected.not_to be_able_to(:read, resource) }
          end
        end
      end

      describe "#attachment_permissions", attachments: true do
        context "object can have attachments" do
          let(:resource) { FactoryGirl.build(:test_model_omnibus) }
          context "and user lacks edit rights" do
            before { subject.cannot(:edit, resource) }
            it { is_expected.not_to be_able_to(:add_attachment, resource) }
          end
          context "and user has edit rights" do
            before { subject.can(:edit, resource) }
            it { is_expected.to be_able_to(:add_attachment, resource) }
          end
        end
        context "object cannot have attachments" do
          let(:resource) { FactoryGirl.build(:test_model) }
          before { subject.can(:edit, resource) }
          it { is_expected.not_to be_able_to(:add_attachment, resource) }
        end
      end

      describe "#children_permissions", children: true do
        context "user has edit rights on object" do
          before { subject.can(:edit, resource) }
          context "and object can have children" do
            let(:resource) { FactoryGirl.build(:collection) }
            it { is_expected.to be_able_to(:add_children, resource) }
          end
          context "but object cannot have children" do
            let(:resource) { FactoryGirl.build(:component) }
            it { is_expected.not_to be_able_to(:add_children, resource) }
          end
        end
        context "user lacks edit rights on attached_to object" do
          let(:resource) { FactoryGirl.build(:collection) }
          before { subject.cannot(:edit, resource) }
          it { is_expected.not_to be_able_to(:add_children, resource) }
        end    
      end

    end
  end
end
