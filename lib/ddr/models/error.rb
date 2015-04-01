module Ddr
  module Models
    # Base class for custom exceptions
    class Error < StandardError; end

    # Invalid checksum
    class ChecksumInvalid < Error; end

    # Derivative generation failure
    class DerivativeGenerationFailure < Error; end
  end
end
