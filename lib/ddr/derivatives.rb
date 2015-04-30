module Ddr
  module Derivatives
    extend ActiveSupport::Autoload

    autoload :Generator
    autoload :PngGenerator
    autoload :PtifGenerator

    Derivative = Struct.new(:name, :datastream, :generator, :options)

    # Eventually, we should inject the generator (probably) and the options (certainly) for each derivative
    # (e.g., from configuration)
    DERIVATIVES = { multires_image:
                        Derivative.new( :multires_image,
                                        Ddr::Datastreams::MULTIRES_IMAGE,
                                        Ddr::Derivatives::PtifGenerator,
                                        "jpeg:90,tile:256x256,pyramid"),
                    thumbnail:
                        Derivative.new( :thumbnail,
                                        Ddr::Datastreams::THUMBNAIL,
                                        Ddr::Derivatives::PngGenerator,
                                        "-resize '100x100>'")
                  }

  end
end
