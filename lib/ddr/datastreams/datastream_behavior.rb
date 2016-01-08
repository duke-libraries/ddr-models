module Ddr::Datastreams
  module DatastreamBehavior
    extend Deprecation

    DEFAULT_FILE_EXTENSION = "bin"
    STRFTIME_FORMAT = "%Y-%m-%dT%H:%M:%S.%LZ"

    def dsid
      Deprecation.warn(DatastreamBehavior,
                       "`dsid` is no longer a datastream/file method. Use `File.basename(id)`.")
      if id
        ::File.basename(id)
      end
    end

    def dsCreateDate
      Deprecation.warn(DatastreamBehavior,
                       "`dsCreateDate` is no longer a datastream/file method. Use `create_date` instead.")
      create_date
    end

    def validate_checksum!(checksum_value, checksum_type=nil)
      raise Ddr::Models::Error, "Checksum cannot be validated on new datastream." if new_record?
      raise Ddr::Models::Error, "Checksum cannot be validated on unpersisted content." if content_changed?
      raise Ddr::Models::ChecksumInvalid, "The repository internal checksum validation failed." unless check_fixity
      algorithm = checksum_type || checksum.algorithm
      calculated_checksum = if algorithm == checksum.algorithm
                              checksum.value
                            else
                              content_digest(algorithm)
                            end
      if checksum_value == calculated_checksum
        "The checksum #{algorithm}:#{checksum_value} is valid for datastream #{dsid}."
      else
        raise Ddr::Models::ChecksumInvalid, "The checksum #{algorithm}:#{checksum_value} is not valid for datastream #{dsid}."
      end
    end

    def create_date_string
      dsCreateDate.strftime(STRFTIME_FORMAT) if dsCreateDate
    end

    def content_digest(algorithm)
      Ddr::Utils.digest(content, algorithm)
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
