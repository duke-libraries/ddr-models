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

      define_model_callbacks :deaccession

      extend Deprecation
      # Deprecate Hydra permissions-related methods
      deprecation_deprecate *(Hydra::AccessControls::Permissions.public_instance_methods)

      before_create :set_ingestion_date, unless: :ingestion_date
      before_create :set_ingested_by, if: :performed_by, unless: :ingested_by

      after_create :notify_ingestion
      after_create :assign_permanent_id!, if: :assign_permanent_id?

      around_save :notify_update, unless: :new_record?
      around_save :notify_workflow_change, if: [:workflow_state_changed?, :persisted?]

      after_deaccession :notify_deaccession
      after_destroy :notify_deletion

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
        cache.with(options) { super }
      end

      private

      def cache
        @__cache ||= Cache.new
      end

      def performed_by
        if user = cache.get(:user)
          user.to_s
        end
      end

      def set_ingested_by
        self.ingested_by = performed_by
      end

      def set_ingestion_date
        self.ingestion_date = Time.now.utc.iso8601
      end

      def default_notification_payload
        cache.slice(:summary, :comment, :detail)
          .merge(pid: pid, user_key: performed_by, permanent_id: permanent_id)
      end

      def notify_ingestion
        event_name = "ingestion.#{self.class.to_s.underscore}.repo_object"
        payload = default_notification_payload.merge(event_date_time: ingestion_date)
        ActiveSupport::Notifications.instrument(event_name, payload)
      end

      def notify_update
        event_name = "update.#{self.class.to_s.underscore}.repo_object"
        ds_changed = datastreams.select { |dsid, ds| ds.content_changed? }.keys
        detail = ["Attributes: #{changes}", "Datastreams: #{ds_changed}"]
        event_params = default_notification_payload
        if extra_detail = event_params[:detail]
          detail << extra_detail
        end
        event_params[:detail] = detail.join("\n\n")
        ActiveSupport::Notifications.instrument(event_name, event_params) do |payload|
          yield
          payload[:event_date_time] = modified_date
        end
      end

      def notify_workflow_change
        event_name = "#{workflow_state}.workflow.#{self.class.to_s.underscore}.repo_object"
        ActiveSupport::Notifications.instrument(event_name, default_notification_payload) do |payload|
          yield
        end
      end

      def notify_deaccession
        event_name = "deaccession.#{self.class.to_s.underscore}.repo_object"
        ActiveSupport::Notifications.instrument(event_name, default_notification_payload)
      end

      def notify_deletion
        event_name = "deletion.#{self.class.to_s.underscore}.repo_object"
        ActiveSupport::Notifications.instrument(event_name, default_notification_payload)
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
