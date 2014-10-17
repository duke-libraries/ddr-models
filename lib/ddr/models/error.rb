module Ddr
  module Models
    # Base class for custom exceptions
    class Error < StandardError; end
  
    # Invalid checksum
    class ChecksumInvalid < Ddr::Models::Error; end

    # Virus found
    class VirusFoundError < Ddr::Models::Error; end
  end
end