require 'open3'

module Ddr
  module Derivatives
    class PngGenerator < Generator

      def self.output_mime_type
        "image/png"
      end

      def generate
        command = "convert #{Ddr::Utils.file_path(source)}[0] #{options} png:#{Ddr::Utils.file_path(output)}"
        out, err, s = Open3.capture3(command)
        GeneratorResult.new(out, err, s)
      end

    end
  end
end
