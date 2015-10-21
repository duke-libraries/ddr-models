module Ddr
  module Datastreams
    module DatastreamBehavior

      DEFAULT_FILE_EXTENSION = "bin"

      STRFTIME_FORMAT = "%Y-%m-%dT%H:%M:%S.%LZ"

      def dsid
        warn "[DEPRECATION] `dsid` is no longer a datastream/file method." \
             " Use `File.basename(id)`."
        if id
          ::File.basename(id)
        end
      end

      def dsCreateDate
        warn "[DEPRECATION] `dsCreateDate` is no longer a datastream/file method." \
             " Use `create_date` instead."
        create_date
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

      def create_date_string
        dsCreateDate.strftime(STRFTIME_FORMAT) if dsCreateDate
      end

      def content_digest algorithm
        Ddr::Utils.digest(self.content, algorithm)
      end

      # Return default file extension for datastream based on MIME type
      def default_file_extension
        mimetypes = MIME::Types[mime_type]
        return mimetypes.first.extensions.first unless mimetypes.empty?
        case mime_type
        when 'application/n-triples'
          'txt'
        else
          DEFAULT_FILE_EXTENSION
        end
      end

      def default_file_prefix
        (id && id.gsub(/\//, "_")) || "NEW"
      end

      # Return default file name
      def default_file_name
        [ default_file_prefix, default_file_extension ].join(".")
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

    end
  end
end
