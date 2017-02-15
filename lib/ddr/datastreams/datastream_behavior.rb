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

      # Returns a list of the external file paths for all versions of the datastream.
      def file_paths
        raise "The `file_paths' method is valid only for external datastreams." unless external?
        return Array(file_path) if new?
        versions.map(&:file_path).compact
      end

      # Returns the external file path for the datastream.
      # Returns nil if dsLocation is not a file URI.
      def file_path
        raise "The `file_path' method is valid only for external datastreams." unless external?
        Ddr::Utils.path_from_uri(dsLocation) if Ddr::Utils.file_uri?(dsLocation)
      end

      # Returns the file name of the external file for the datastream.
      # See #external_datastream_file_path(ds)
      def file_name
        raise "The `file_name' method is valid only for external datastreams." unless external?
        File.basename(file_path) rescue nil
      end

      # Returns the size of the external file for the datastream.
      def file_size
        raise "The `file_size' method is valid only for external datastreams." unless external?
        File.size(file_path) rescue nil
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
        { pid: pid, file_id: dsid }
      end

      def notify_save
        ActiveSupport::Notifications.instrument(
          Ddr::Datastreams::SAVE,
          default_notification_payload.merge(attributes_changed: changes)
        ) do |payload|
          yield
          payload[:profile] = profile
        end
      end

      def notify_delete
        ActiveSupport::Notifications.instrument(
          Ddr::Datastreams::DELETE,
          default_notification_payload.merge(profile: profile)
        ) do |payload|
          yield
        end
      end

    end
  end
end
