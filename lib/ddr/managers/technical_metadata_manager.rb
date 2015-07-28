module Ddr::Managers
  class TechnicalMetadataManager < Manager

    delegate :fits, to: :object

    # FITS output sections
    delegate :filestatus, :fileinfo, :identification, :metadata, to: :fits

    # FITS filestatus section
    delegate :valid, :well_formed, to: :filestatus

    # FITS identification section
    delegate :identity, to: :identification

    # FITS identity data points
    delegate :mimetype, :format_label, :format_version, :pronom_identifier, to: :identity

    # FITS fileinfo elements
    delegate :created, :lastmodified, :creating_application, :file_size, to: :fileinfo

    # FITS format-specific metadata elements
    delegate :image, :document, :text, :audio, :video, to: :metadata

    # FITS image metadata elements
    delegate :image_width, :image_height, :color_space, to: :image

    def fits_version
      fits.version.first
    end

    # def fits_datetime
    #   DateTime.strptime(fits.timestamp.first, "%D %l:%M %p")
    # end

  end
end
