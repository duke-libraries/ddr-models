module Ddr
  module Models
    # Base class for custom exceptions
    class Error < StandardError; end

    # Invalid checksum
    class ChecksumInvalid < Error; end

    # Derivative generation failure
    class DerivativeGenerationFailure < Error; end

    # Content model casting error
    class ContentModelError < Error; end
  end
end
