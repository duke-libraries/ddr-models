module Ddr
  module Models
    # Base class for custom exceptions
    class Error < StandardError; end
  
    # Invalid checksum
    class ChecksumInvalid < Error; end
  end
end
