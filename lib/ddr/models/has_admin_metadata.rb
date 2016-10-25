require "resque"

module Ddr::Models
  module HasAdminMetadata
    extend ActiveSupport::Concern

    included do
      has_metadata "adminMetadata",
                   type: Ddr::Datastreams::AdministrativeMetadataDatastream,
                   versionable: true,
                   control_group: "M"

      has_attributes :admin_set,
                     :depositor,
                     :display_format,
                     :license,
                     :local_id,
                     :permanent_id,
                     :permanent_url,
                     :research_help_contact,
                     :workflow_state,
                     :ead_id,
                     :aspace_id,
                     :is_locked,
                     datastream: "adminMetadata",
                     multiple: false

      delegate :publish!, :unpublish!, :published?, to: :workflow

      after_create :assign_permanent_id!, if: "Ddr::Models.auto_assign_permanent_ids"
    end

    def permanent_id_manager
      @permanent_id_manager ||= Ddr::Managers::PermanentIdManager.new(self)
    end

    def roles
      Ddr::Auth::Roles::PropertyRoleSet.new(adminMetadata.access_role)
    end

    def inherited_roles
      Ddr::Auth::InheritedRoles.call(self)
    end

    def workflow
      @workflow ||= Ddr::Managers::WorkflowManager.new(self)
    end

    def assign_permanent_id!
      permanent_id_manager.assign_later
    end

    def grant_roles_to_creator(creator)
      roles.grant type: Ddr::Auth::Roles::EDITOR,
                  agent: creator,
                  scope: Ddr::Auth::Roles::RESOURCE_SCOPE
    end

    def copy_resource_roles_from(other)
      roles.grant *(other.roles.in_resource_scope)
    end

    def effective_permissions(agents)
      Ddr::Auth::EffectivePermissions.call(self, agents)
    end

    def research_help
      Ddr::Models::Contact.call(research_help_contact) if research_help_contact
    end

    def effective_license
      EffectiveLicense.call(self)
    end

    def inherited_license
      InheritedLicense.call(self)
    end

    def finding_aid
      if ead_id
        FindingAid.new(ead_id)
      end
    end

    def locked?
      !!is_locked
    end

    def lock
      self.is_locked = true
    end

    def unlock
      self.is_locked = false
    end

    def lock!
      lock
      save
    end

    def unlock!
      unlock
      save
    end

    private

    def update_permanent_id_on_destroy
      @permanent_id = permanent_id
      yield
      Resque.enqueue(Ddr::Jobs::PermanentId::MakeUnavailable, @permanent_id, "deleted")
    end

  end
end
