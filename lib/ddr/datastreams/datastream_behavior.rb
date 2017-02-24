module Ddr
  module Datastreams
    module DatastreamBehavior
      extend ActiveSupport::Concern

      DEFAULT_FILE_EXTENSION = "bin"

      STRFTIME_FORMAT = "%Y-%m-%dT%H:%M:%S.%LZ"

      included do
        around_save :notify_save
        around_destroy :notify_delete
      end

      def validate_checksum! checksum, checksum_type=nil
        raise Ddr::Models::Error, "Checksum cannot be validated on new datastream." if new?
        raise Ddr::Models::Error, "Checksum cannot be validated on unpersisted content." if content_changed?
        raise Ddr::Models::ChecksumInvalid, "The repository internal checksum validation failed." unless dsChecksumValid
        algorithm = checksum_type || self.checksumType
        ds_checksum = if algorithm == self.checksumType
                        self.checksum
                      else
                        content_digest(algorithm)
                      end
        if checksum == ds_checksum
          "The checksum [#{algorithm}]#{checksum} is valid for datastream #{version_info}."
        else
          raise Ddr::Models::ChecksumInvalid, "The checksum [#{algorithm}]#{checksum} is not valid for datastream #{version_info}."
        end
      end

      def version_history
        versions.map(&:profile)
      end

      def version_uri
        # E.g., info:fedora/duke:1/content/content.0
        ["info:fedora", pid, dsid, dsVersionID].join("/") unless new?
      end

      def version_info
        # E.g., info:fedora/duke:1/content/content.0 [2013-09-26T20:00:03.357Z]
        "#{version_uri} [#{Ddr::Utils.ds_as_of_date_time(self)}]" unless new?
      end

      def create_date_string
        dsCreateDate.strftime(STRFTIME_FORMAT) if dsCreateDate
      end

      def content_digest algorithm
        Ddr::Utils.digest(self.content, algorithm)
      end

      def file_paths
        if new?
          return Array(file_path)
        else
          versions.map(&:file_path).compact
        end
      end

      def file_path
        if external?
          Ddr::Utils.path_from_uri(dsLocation) if Ddr::Utils.file_uri?(dsLocation)
        elsif managed?
          # TODO
        end
      end

      def file_name
        if path = file_path
          File.basename(path)
        end
      end

      # Returns the size of the external file for the datastream.
      def file_size
        if external?
          if path = file_path
            File.size(path)
          end
        else
          dsSize
        end
      end

      # Return default file extension for datastream based on MIME type
      def default_file_extension
        mimetypes = MIME::Types[mimeType]
        return mimetypes.first.extensions.first unless mimetypes.empty?
        case mimeType
        when 'application/n-triples'
          'txt'
        else
          DEFAULT_FILE_EXTENSION
        end
      end

      # Return default file name prefix based on object PID
      def default_file_prefix
        [pid.sub(/:/, '_'), dsid].join("_")
      end

      # Return default file name
      def default_file_name
        [default_file_prefix, default_file_extension].join(".")
      end

      def tempfile(prefix: nil, suffix: nil)
        if empty?
          raise Ddr::Models::Error, "Refusing to create tempfile for empty datastream!"
        end
        prefix ||= default_file_prefix + "--"
        suffix ||= "." + default_file_extension
        Tempfile.open [prefix, suffix], encoding: Encoding::ASCII_8BIT do |f|
          f.write(content)
          f.close
          yield f
        end
      end

      private

      def default_notification_payload
        { pid: pid, file_id: dsid, control_group: controlGroup }
      end

      def delete_notification_payload
        default_notification_payload.merge(
          profile: profile.dup,
          version_history: version_history
        )
      end

      def notify_save
        ActiveSupport::Notifications.instrument(
          Ddr::Datastreams::SAVE,
          default_notification_payload.merge(attributes_changed: changes)
        ) do |payload|
          yield
          payload[:profile] = profile.dup
        end
      end

      def notify_delete
        ActiveSupport::Notifications.instrument(
          Ddr::Datastreams::DELETE, delete_notification_payload
        ) do |payload|
          yield
        end
      end

    end
  end
end
