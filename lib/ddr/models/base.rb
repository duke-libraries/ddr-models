module Ddr
  module Models
    class Base < ActiveFedora::Base

      # Lifecycle events
      INGEST = "ingest.repo_object"
      UPDATE = "update.repo_object"
      DELETE = "delete.repo_object"
      DEACCESSION = "deaccession.repo_object"

      include Describable
      include Governable
      include HasThumbnail
      include EventLoggable
      include FixityCheckable
      include FileManagement
      include Indexing
      include Hydra::Validations
      include HasAdminMetadata
      extend Deprecation

      # Prevent accidental use of #delete which lacks callbacks
      private :delete

      define_model_callbacks :deaccession

      before_create :set_ingestion_date, unless: :ingestion_date
      before_create :set_ingested_by, if: :performed_by, unless: :ingested_by
      before_create :grant_default_roles

      after_create :notify_ingest
      after_create :assign_permanent_id!, if: :assign_permanent_id?

      around_save :notify_update, unless: :new_record?

      after_deaccession :notify_deaccession
      after_destroy :notify_delete

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

      def publishable?
        raise NotImplementedError, "Must be implemented by subclasses"
      end

      def save(options={})
        cache.with(options) { super }
      end

      def datastreams_changed
        datastreams.select { |dsid, ds| ds.changed? }
      end

      private

      def grant_default_roles
        if default_roles.present?
          roles.grant *default_roles
        end
      end

      def default_roles
        []
      end

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
          .merge(pid: pid,
                 user_key: performed_by,
                 permanent_id: permanent_id,
                 model: self.class.to_s)
      end

      def notify_ingest
        payload = default_notification_payload.merge(
          event_date_time: ingestion_date,
          datastreams_changed: attached_files_having_content.keys
        )
        ActiveSupport::Notifications.instrument(INGEST, payload)
      end

      def notify_update
        event_params = default_notification_payload.merge(
          attributes_changed: changes,
          datastreams_changed: datastreams_changed.keys
        )
        ActiveSupport::Notifications.instrument(UPDATE, event_params) do |payload|
          yield
          payload[:event_date_time] = modified_date
        end
      end

      def notify_deaccession
        ActiveSupport::Notifications.instrument(DEACCESSION, default_notification_payload)
      end

      def notify_delete
        ActiveSupport::Notifications.instrument(DELETE, default_notification_payload)
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
