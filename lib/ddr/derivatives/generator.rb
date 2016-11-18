module Ddr
  module Derivatives
    # @abstract
    class Generator

      attr_reader :source, :output, :options

      def initialize source, output, options=nil
        raise ArgumentError, "Source must be a File or path to a file" unless Ddr::Utils.file_or_path?(source)
        raise ArgumentError, "Output must be a File or path to a file" unless Ddr::Utils.file_or_path?(output)
        @source = source
        @output = output
        @options = options
      end

      # The mime type of the output generated.
      # Implemented in each subclass.
      def self.output_mime_type
        raise NotImplementedError
      end

      # The actions required to generate the output from the source.
      # Implemented in each subclass.
      def generate
        raise NotImplementedError
      end
    end
  end
end
