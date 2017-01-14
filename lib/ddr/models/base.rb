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
      before_create :set_ingestion_date!, unless: :ingestion_date
      after_create :notify_create
      after_create :assign_permanent_id!, if: :assign_permanent_id?
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

      def publishable?
        raise NotImplementedError, "Must be implemented by subclasses"
      end

      def save(options={})
        handle_save_options(options)
        super
      end

      def save!(options={})
        handle_save_options(options)
        super
      end

      private

      def handle_save_options(options)
        if user = options.delete(:user)
          if new_record? && ingested_by.nil?
            set_ingested_by(user)
          end
        end
      end

      def set_ingested_by(user)
        self.ingested_by = user.to_s
      end

      def set_ingestion_date!
        self.ingestion_date = Time.now.utc.iso8601
      end

      def notify_create
        ActiveSupport::Notifications.instrument("create.#{self.class.to_s.underscore}",
                                                pid: pid)
      end

      def notify_save
        ActiveSupport::Notifications.instrument("save.#{self.class.to_s.underscore}",
                                                pid: pid,
                                                changes: changes,
                                                created: new_record?) do |payload|
          yield
        end
      end

      def notify_workflow_change
        ActiveSupport::Notifications.instrument("#{workflow_state}.workflow.#{self.class.to_s.underscore}",
                                                pid: pid) do |payload|
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

      def assign_permanent_id!
        PermanentId.assign!(self)
      end

    end
  end
end
