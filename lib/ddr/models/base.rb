module Ddr
  module Models
    class Base < ActiveFedora::Base

      include Describable
      include Governable
      include AccessControllable
      include HasThumbnail
      include EventLoggable
      include FixityCheckable
      include FileManagement
      include Indexing
      include Hydra::Validations
      include HasAdminMetadata

      # Prevent accidental use of #delete which lacks callbacks
      private :delete

      define_model_callbacks :deaccession, only: :around

      extend Deprecation
      # Deprecate Hydra permissions-related methods
      deprecation_deprecate *(Hydra::AccessControls::Permissions.public_instance_methods)

      around_save :notify_save
      around_save :notify_workflow_change, if: [:workflow_state_changed?, :persisted?]
      before_create :set_ingestion_date, unless: :ingestion_date
      after_create :assign_permanent_id, if: :assign_permanent_id?
      around_deaccession :notify_deaccession
      around_destroy :notify_destroy

      def deaccession
        run_callbacks :deaccession do
          delete
        end
      end

      def copy_admin_policy_or_permissions_from(other)
        Deprecation.warn(self.class, "`copy_admin_policy_or_permissions_from` is deprecated." \
                                     " Use `copy_admin_policy_or_roles_from` instead.")
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

      def publishable?
        raise NotImplementedError, "Must be implemented by subclasses"
      end

      def set_ingestion_date
        raise Error, "Ingestion date is already set, cannot overwrite." if ingestion_date
        if new_record?
          self.ingestion_date = Time.now.utc.iso8601
        else
          event = Ddr::Events::IngestionEvent.for_object(self).first ||
                  Ddr::Events::CreationEvent.for_object(self).first
          self.ingestion_date = event ? event.event_date_time_s : create_date
        end
      end

      private

      def notify_save
        ActiveSupport::Notifications.instrument("save.#{self.class.to_s.underscore}",
                                                pid: pid,
                                                changes: changes,
                                                created: new_record?) do |payload|
          yield
        end
      end

      def notify_workflow_change
        ActiveSupport::Notifications.instrument("#{workflow_state}.workflow.#{self.class.to_s.underscore}", pid: pid) do |payload|
          yield
        end
      end

      def notify_deaccession
        ActiveSupport::Notifications.instrument("deaccession.#{self.class.to_s.underscore}",
                                                pid: pid,
                                                permanent_id: permanent_id) do |payload|
          yield
        end
      end

      def notify_destroy
        ActiveSupport::Notifications.instrument("destroy.#{self.class.to_s.underscore}",
                                                pid: pid,
                                                permanent_id: permanent_id) do |payload|
          yield
        end
      end

      def assign_permanent_id?
        permanent_id.nil? && Ddr::Models.auto_assign_permanent_id
      end

      def assign_permanent_id
        PermanentId.assign!(self)
      end

    end
  end
end
