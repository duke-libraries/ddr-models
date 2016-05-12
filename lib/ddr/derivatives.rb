module Ddr
  module Derivatives
    extend ActiveSupport::Autoload

    autoload :Derivative
    autoload :MultiresImage
    autoload :Thumbnail

    autoload_under 'generators' do
      autoload :Generator
      autoload :PngGenerator
      autoload :PtifGenerator
    end

    # Derivatives to generate.  Array of DERIVATIVE names
    mattr_accessor :update_derivatives

    # Eventually, we should inject the generator (probably) and the options (certainly) for each derivative
    # (e.g., from configuration)
    DERIVATIVES = {
        multires_image: Ddr::Derivatives::MultiresImage.new(
            Ddr::Derivatives::PtifGenerator.new("jpeg:90,tile:256x256,pyramid")),
        thumbnail: Ddr::Derivatives::Thumbnail.new(
            Ddr::Derivatives::PngGenerator.new("-resize '100x100>'"))
    }

    # Yields an object with module configuration accessors
    def self.configure
      yield self
    end

  end
end
