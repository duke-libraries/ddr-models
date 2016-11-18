module Ddr
  module Derivatives
    class PngGenerator < Generator

      def self.output_mime_type
        "image/png"
      end

      def generate
        command = "convert #{Ddr::Utils.file_path(source)}[0] #{options} png:#{Ddr::Utils.file_path(output)}"
        `#{command}`
        $?.exitstatus
      end

    end
  end
end
