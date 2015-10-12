require "resque"
require "rdf/vocab"

module Ddr::Models
  module HasAdminMetadata
    extend ActiveSupport::Concern

    included do
      property :access_role,
               predicate: Ddr::Vocab::Roles.hasRole,
               class_name: Ddr::Auth::Roles::Role

      property :admin_set,
               predicate: Ddr::Vocab::Asset.adminSet,
               multiple: false

      property :depositor,
               predicate: RDF::Vocab::MARCRelators.dpt,
               multiple: false

      property :display_format,
               predicate: Ddr::Vocab::Display.format,
               multiple: false

      property :doi,
               predicate: RDF::Vocab::Identifiers.doi

      property :ead_id,
               predicate: Ddr::Vocab::Asset.eadId,
               multiple: false

      property :license,
               predicate: RDF::DC.license,
               multiple: false

      property :local_id,
               predicate: RDF::Vocab::Identifiers.local,
               multiple: false

      # XXX Is this admin metadata?
      property :original_filename,
               predicate: Ddr::Vocab::PREMIS.hasOriginalName,
               multiple: false do |index|
        index.as :stored_sortable
      end

      property :permanent_id,
               predicate: Ddr::Vocab::Asset.permanentId,
               multiple: false

      property :permanent_url,
               predicate: Ddr::Vocab::Asset.permanentUrl,
               multiple: false

      property :research_help_contact,
               predicate: Ddr::Vocab::Contact.assistance,
               multiple: false

      property :workflow_state,
               predicate: Ddr::Vocab::Asset.workflowState,
               multiple: false

      delegate :publish, :publish!, :unpublish, :unpublish!, :published?, to: :workflow

      after_create :assign_permanent_id!, if: "Ddr::Models.auto_assign_permanent_ids"
      around_destroy :update_permanent_id_on_destroy, if: "permanent_id.present?"
    end

    def permanent_id_manager
      @permanent_id_manager ||= Ddr::Managers::PermanentIdManager.new(self)
    end

    def roles
      Ddr::Auth::Roles::PropertyRoleSet.new(access_role)
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
      Ddr::Contacts.get(research_help_contact) if research_help_contact
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

    private

    def update_permanent_id_on_destroy
      @permanent_id = permanent_id
      yield
      Resque.enqueue(Ddr::Jobs::PermanentId::MakeUnavailable, @permanent_id, "deleted")
    end

  end
end
