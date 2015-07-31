module Ddr::Managers
  class TechnicalMetadataManager < Manager

    FITS_TIMESTAMP_FORMAT = "%D %l:%M %p" # Ex. 7/3/15 8:29 PM

    delegate :content, :fits, to: :object

    delegate :valid, :well_formed,
             :media_type, :format_label, :format_version, :pronom_identifier,
             :created, :modified, :creating_application, :extent,
             :image_width, :image_height, :color_space,
             to: :fits

    alias_method :file_size, :extent
    alias_method :last_modified, :modified

    def fits?
      !fits_version.nil?
    end

    def fits_version
      fits.version.first
    end

    def fits_datetime
      if fits_timestamp = fits.timestamp.first
        no_zone = DateTime.strptime(fits_timestamp, FITS_TIMESTAMP_FORMAT)
        no_zone.change(offset: no_zone.to_time.zone)
      end
    end

    def file_human_size
      file_size.map do |fs|
        num = fs.to_i
        "%s (%s bytes)" % [ ActiveSupport::NumberHelper.number_to_human_size(n),
                            ActiveSupport::NumberHelper.number_to_delimited(n) ]
      end
    end

    def checksum_digest
      content.checksumType
    end

    def checksum_value
      content.checksum
    end

    def invalid?
      valid.any? { |v| v == "false" }
    end

    def valid?
      !invalid?
    end

    def ill_formed?
      well_formed.any? { |v| v == "false" }
    end

    def well_formed?
      !ill_formed?
    end

  end
end
