module Ddr
  module Models
    class Base < ActiveFedora::Base

      include Describable
      include Governable
      include AccessControllable
      include HasProperties
      include HasThumbnail
      include EventLoggable
      include FixityCheckable
      include FileManagement
      include Indexing
      include Hydra::Validations
      include HasAdminMetadata

      extend Deprecation
      # Deprecate Hydra permissions-related methods
      deprecation_deprecate *(Hydra::AccessControls::Permissions.public_instance_methods)

      after_destroy do
        notify_event :deletion
      end

      def copy_admin_policy_or_permissions_from(other)
        warn "[DEPRECATION] `copy_admin_policy_or_permissions_from` is deprecated." \
             " Use `copy_admin_policy_or_roles_from` instead." \
             " (#{caller.first})."
        copy_admin_policy_or_roles_from(other)
      end

      def copy_admin_policy_or_roles_from(other)
        copy_resource_roles_from(other) unless copy_admin_policy_from(other)
      end

      def association_query(association)
        # XXX Ideally we would include a clause to limit by AF model, but this should suffice
        ActiveFedora::SolrService.construct_query_for_rel(reflections[association].options[:property] => internal_uri)
      end

      # e.g., "Collection duke:1"
      def model_pid
        [self.class.to_s, pid].join(" ")
      end

      # @override ActiveFedora::Core
      # See ActiveFedora overrides in engine initializers
      def adapt_to_cmodel
        super
      rescue ::TypeError
        raise ContentModelError, "Cannot adapt to nil content model."
      end

      def has_extracted_text?
        false
      end

      def legacy_authorization
        Ddr::Auth::LegacyAuthorization.new(self)
      end

      # Moves the first (descriptive metadata) identifier into
      # (administrative metadata) local_id according to the following
      # rubric:
      #
      # No existing local_id:
      #   - Set local_id to first identifier value
      #   - Remove first identifier value
      #
      # Existing local_id:
      #   Same as first identifier value
      #     - Remove first identifier value
      #   Not same as first identifier value
      #     :replace option is true
      #       - Set local_id to first identifier value
      #       - Remove first identifier value
      #     :replace option is false
      #       - Do nothing
      #
      # Returns true or false depending on whether the object was
      # changed by this method
      def move_first_identifier_to_local_id(replace: true)
        moved = false
        identifiers = identifier.to_a
        first_id = identifiers.shift
        if first_id
          if local_id.blank?
            self.local_id = first_id
            self.identifier = identifiers
            moved = true
          else
            if local_id == first_id
              self.identifier = identifiers
              moved = true
            else
              if replace
                self.local_id = first_id
                self.identifier = identifiers
                moved = true
              end
            end
          end
        end
        moved
      end

    end
  end
end
