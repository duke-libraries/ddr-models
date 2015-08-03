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

    def file_size
      extent.map(&:to_i)
    end

    def file_human_size
      file_size.map do |fs|
        "%s (%s bytes)" % [ ActiveSupport::NumberHelper.number_to_human_size(fs),
                            ActiveSupport::NumberHelper.number_to_delimited(fs) ]
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

    def creation_time
      created.map { |datestr| coerce_to_time(datestr) }.compact
    end

    def modification_time
      modified.map { |datestr| coerce_to_time(datestr) }.compact
    end

    def index_fields
      { Ddr::IndexFields::TECHMD_FITS_VERSION      => fits_version,
        Ddr::IndexFields::TECHMD_FITS_DATETIME     => Ddr::Utils.solr_date(fits_datetime),
        Ddr::IndexFields::TECHMD_CREATION_TIME     => Ddr::Utils.solr_dates(creation_time),
        Ddr::IndexFields::TECHMD_MODIFICATION_TIME => Ddr::Utils.solr_dates(modification_time),
        Ddr::IndexFields::TECHMD_COLOR_SPACE       => color_space,
        Ddr::IndexFields::TECHMD_CREATING_APPLICATION => creating_application,
        Ddr::IndexFields::TECHMD_FILE_SIZE         => file_size,
        Ddr::IndexFields::TECHMD_FORMAT_LABEL      => format_label,
        Ddr::IndexFields::TECHMD_FORMAT_VERSION    => format_version,
        Ddr::IndexFields::TECHMD_IMAGE_HEIGHT      => image_height,
        Ddr::IndexFields::TECHMD_IMAGE_WIDTH       => image_width,
        Ddr::IndexFields::TECHMD_MEDIA_TYPE        => media_type,
        Ddr::IndexFields::TECHMD_PRONOM_IDENTIFIER => pronom_identifier,
        Ddr::IndexFields::TECHMD_VALID             => valid,
        Ddr::IndexFields::TECHMD_WELL_FORMED       => well_formed,
      }
    end

    private

    def coerce_to_time(datestr)
      datestr.sub! /\A(\d+):(\d+):(\d+)/, '\1-\2-\3'
      DateTime.parse(datestr).to_time
    rescue ArgumentError
      nil
    end

  end
end
