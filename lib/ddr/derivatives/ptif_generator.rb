module Ddr
  module Derivatives
    class PtifGenerator < Generator

      def self.output_mime_type
        "image/tiff"
      end

      def generate
        command = "convert #{Ddr::Utils.file_path(source)} #{options} ptif:#{Ddr::Utils.file_path(output)}"
        out, err, s = Open3.capture3(command)
        GeneratorResult.new(out, err, s)
      end

    end
  end
end