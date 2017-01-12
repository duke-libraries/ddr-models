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
                     :doi,
                     datastream: "adminMetadata",
                     multiple: false

      delegate :publish!, :unpublish!, :published?, :unpublished?,
               to: :workflow
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
      !!is_locked || Ddr::Models.repository_locked
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

  end
end
