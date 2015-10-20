require 'open3'

module Ddr
  module Derivatives
    class PngGenerator < Generator

      def self.output_mime_type
        "image/png"
      end

      def self.output_extension
        "png"
      end

      def generate(source_path, output_path)
        command = "convert #{source_path} #{options} png:#{output_path}"
        out, err, s = Open3.capture3(command)
        GeneratorResult.new(output_path, out, err, s)
      end

    end
  end
end
