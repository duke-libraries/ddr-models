module Ddr
  module Derivatives
    # @abstract
    class Generator

      attr_reader :options

      GeneratorResult = Struct.new(:output_path, :stdout, :stderr, :status)

      def initialize(options=nil)
        @options = options
      end

      # The mime type of the output generated.
      # Implemented in each subclass.
      def self.output_mime_type
        raise NotImplementedError
      end

      # The extension to use for the output generated.
      # Implemented in each subclass
      def self.output_extension
        raise NotImplementedError
      end

      # The actions required to generate the output from the source.
      # Implemented in each subclass.
      def generate(source_path, output_path)
        raise NotImplementedError
      end
    end
  end
end
