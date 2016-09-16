module Ddr::Auth
  RSpec.describe Ability, type: :model, abilities: true do

    subject { described_class.new(auth_context) }

    let(:auth_context) { FactoryGirl.build(:auth_context) }

    describe "aliases" do
      it "should have :replace aliases" do
        expect(subject.aliased_actions[:replace]).to contain_exactly(:upload)
      end
      it "should have :add_children aliases" do
        expect(subject.aliased_actions[:add_children]).to contain_exactly(:add_attachment)
      end
    end

    describe "Datastream abilities" do
      let(:obj) { FactoryGirl.build(:component) }

      DatastreamAbilityDefinitions::DATASTREAM_DOWNLOAD_ABILITIES.each do |dsid, permission|
        describe "\"#{dsid}\"" do
          let(:ds) { obj.datastreams[dsid] }
          describe "can #{permission.inspect} object" do
            before { subject.can permission, obj.pid }
            it { should be_able_to(:download, ds) }
          end
          describe "cannot #{permission.inspect} object" do
            before { subject.cannot permission, obj.pid }
            it { should_not be_able_to(:download, ds) }
          end
        end
      end

      describe "non-downloadable datastreams" do
        (Component.ds_specs.keys - DatastreamAbilityDefinitions::DATASTREAM_DOWNLOAD_ABILITIES.keys).each do |dsid|
          describe "\"#{dsid}\"" do
            let(:ds) { obj.datastreams[dsid] }
            before { subject.can :download, obj.pid }
            it { should_not be_able_to(:download, ds) }
          end
        end
      end
    end

    describe "Event abilities" do
      let(:event) { FactoryGirl.build(:event) }

      describe "can read object of the event" do
        before { subject.can :read, event.pid }
        it { should be_able_to(:read, event) }
      end

      describe "cannot read object of the event" do
        before { subject.cannot :read, event.pid }
        it { should_not be_able_to(:read, event) }
      end
    end

    describe "Collection abilities" do
      describe "create" do
        before do
          allow(Ddr::Auth).to receive(:collection_creators_group) { "collection_creators" }
        end
        describe "when the user is a collection creator" do
          before do
            allow(auth_context).to receive(:member_of?).with("collection_creators") { true }
          end
          it { should be_able_to(:create, Collection) }
        end

        describe "when the user is not a collection creator" do
          before do
            allow(auth_context).to receive(:member_of?).with("collection_creators") { false }
          end
          it { should_not be_able_to(:create, Collection) }
        end
      end
      describe "export" do
        let(:collection) { FactoryGirl.build(:collection) }
        describe "when the user has read permission via policy scope role" do
          before {
            collection.roles.grant role_type: "Viewer", agent: auth_context.user.to_s, scope: "policy"
          }
          it { is_expected.to be_able_to(:export, collection) }
        end
        describe "when the user does not have read permission via policy scope role" do
          before {
            collection.roles.grant role_type: "Viewer", agent: auth_context.user.to_s
          }
          it { is_expected.not_to be_able_to(:export, collection) }
        end
      end
    end

    describe "Item abilities" do
      let(:item) { FactoryGirl.build(:item) }

      describe "when the item has a parent" do
        let(:parent) { FactoryGirl.create(:collection) }
        before { item.parent = parent }

        describe "and can add children to the parent" do
          before { subject.can :add_children, parent }
          it { should be_able_to(:create, item) }
        end

        describe "and cannot add children to the parent" do
          before { subject.cannot :add_children, parent }
          it { should_not be_able_to(:create, item) }
        end
      end

      describe "when the item does not have a parent" do
        it { should_not be_able_to(:create, item) }
      end
    end

    describe "Component abilities" do
      let(:component) { FactoryGirl.build(:component) }

      describe "when the component has a parent" do
        let(:parent) { FactoryGirl.create(:item) }
        before { component.parent = parent }

        describe "and can add children to the parent" do
          before { subject.can :add_children, parent }
          it { should be_able_to(:create, component) }
        end

        describe "and cannot add children to the parent" do
          before { subject.cannot :add_children, parent }
          it { should_not be_able_to(:create, component) }
        end
      end

      describe "when the component does not have a parent" do
        it { should_not be_able_to(:create, component) }
      end
    end

    describe "Attachment abilities" do
      let(:attachment) { FactoryGirl.build(:attachment) }

      describe "when the attachment is attached" do
        let(:attached_to) { FactoryGirl.create(:collection) }
        before { attachment.attached_to = attached_to }

        describe "and can add attachment to the attached" do
          before { subject.can :add_attachment, attached_to }
          it { should be_able_to(:create, attachment) }
        end

        describe "and cannot add attachment to the attached" do
          before { subject.cannot :add_attachment, attached_to }
          it { should_not be_able_to(:create, attachment) }
        end
      end

      describe "when the attachment is not attached" do
        it { should_not be_able_to(:create, attachment) }
      end
    end

    describe "publication abilities" do
      let(:obj) { Ddr::Models::Base.new }

      describe "publish" do
        describe "when role-based permissions permit publish" do
          before do
            allow(obj).to receive(:effective_permissions) { [ Permissions::PUBLISH ] }
          end
          describe "when the object is published" do
            before { allow(obj).to receive(:published?) { true } }
            it { should_not be_able_to(:publish, obj) }
          end
          describe "when the object is not published" do
            describe "when the object is publishable" do
              before { allow(obj).to receive(:publishable?) { true } }
              it { should be_able_to(:publish, obj) }
            end
            describe "when the object is not publishable" do
              before { allow(obj).to receive(:publishable?) { false } }
              it { should_not be_able_to(:publish, obj) }
            end
          end
        end
        describe "when role-based permissions do not permit publish" do
          before { allow(obj).to receive(:publishable?) { true } }
          it { should_not be_able_to(:publish, obj) }
        end
      end

      describe "unpublish" do
        describe "when role-based permissions permit unpublish" do
          before do
            allow(obj).to receive(:effective_permissions) { [ Permissions::UNPUBLISH ] }
          end
          describe "when the object is published" do
            before { allow(obj).to receive(:published?) { true } }
            it { should be_able_to(:unpublish, obj) }
          end
          describe "when the object is not published" do
            it { should_not be_able_to(:unpublish, obj) }
          end
        end
        describe "when role-based permissions do not permit unpublish" do
          it { should_not be_able_to(:unpublish, obj) }
        end
      end

    end

    describe "locks" do
      let(:obj) { Ddr::Models::Base.new }

      describe "effects of locks on abilities" do
        before do
          allow(obj).to receive(:effective_permissions) { Permissions::ALL }
          allow(obj).to receive(:locked?) { true }
        end
        it { should be_able_to(:read, obj) }
        it { should be_able_to(:download, obj) }
        it { should_not be_able_to(:add_children, obj) }
        it { should_not be_able_to(:update, obj) }
        it { should_not be_able_to(:replace, obj) }
        it { should_not be_able_to(:arrange, obj) }
        it { should be_able_to(:audit, obj) }
        it { should_not be_able_to(:grant, obj) }
      end
    end

    describe "role based abilities" do
      shared_examples "it has role based abilities" do
        describe "when permissions are cached" do
          before { subject.cache[cache_key] = [ Permissions::READ ] }
          it "should use the cached permissions" do
            expect(perm_obj).not_to receive(:effective_permissions)
            expect(subject).to be_able_to(:read, obj)
            expect(subject).not_to be_able_to(:edit, obj)
          end
        end
        describe "when permissions are not cached" do
          describe "and user context has role based permission" do
            before do
              allow(perm_obj).to receive(:effective_permissions) do
                [ Permissions::UPDATE ]
              end
            end
            it { should be_able_to(:edit, obj) }
          end
          describe "and user context does not have role based permission" do
            before do
              allow(perm_obj).to receive(:effective_permissions) do
                [ Permissions::READ ]
              end
            end
            it { should_not be_able_to(:edit, obj) }
          end
        end
      end

      describe "with a Ddr model instance" do
        let(:obj) { Collection.new(pid: "test:1") }
        let(:cache_key) { obj.pid }
        let(:perm_obj) { obj }
        it_behaves_like "it has role based abilities"
      end

      describe "with a Solr document" do
        let(:obj) { SolrDocument.new({"id"=>"test:1"}) }
        let(:cache_key) { obj.pid }
        let(:perm_obj) { obj }
        it_behaves_like "it has role based abilities"
      end

      describe "with a String" do
        let(:obj) { "test:1" }
        let(:cache_key) { obj }
        let(:perm_obj) { SolrDocument.new({"id"=>"test:1"}) }
        before do
          allow_any_instance_of(RoleBasedAbilityDefinitions).to receive(:permissions_doc).with(obj) { perm_obj }
        end
        it_behaves_like "it has role based abilities"
      end
    end

  end
end
