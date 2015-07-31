module Ddr::Managers
  class TechnicalMetadataManager < Manager

    FITS_TIMESTAMP_FORMAT = "%D %l:%M %p" # Ex. 7/3/15 8:29 PM

    delegate :content, :fits, to: :object

    # FITS output sections
    delegate :filestatus, :fileinfo, :identification, :metadata, to: :fits

    # FITS filestatus section
    delegate :valid, :well_formed, to: :filestatus

    # FITS identification section
    delegate :identity, to: :identification

    # FITS identity data points
    delegate :media_type, :format_label, :format_version, :pronom_identifier, to: :identity

    # FITS fileinfo elements
    delegate :created, :last_modified, :creating_application, :size, to: :fileinfo

    # FITS format-specific metadata elements
    delegate :image, :document, :text, :audio, :video, to: :metadata

    # FITS image metadata elements
    delegate :image_width, :image_height, :color_space, to: :image

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

    def file_size
      size.map(&:to_i)
    end

    def file_human_size
      file_size.map do |s|
        "%s (%s bytes)" % [ ActiveSupport::NumberHelper.number_to_human_size(s),
                            ActiveSupport::NumberHelper.number_to_delimited(s) ]
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
