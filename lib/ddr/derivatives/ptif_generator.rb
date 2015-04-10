module Ddr
  module Derivatives
    class PtifGenerator < Generator

      def self.output_mime_type
        "image/tiff"
      end

      def generate
        case source_depth.strip
        when '16'
          Dir.mktmpdir do |dir|
            temp_8_bit = make_8_bit(dir)
            run_generator(temp_8_bit)
          end
        when '8'
          run_generator(source)
        else
          raise Ddr::Models::DerivativeGenerationFailure,
                  "Unexpected depth -- #{source_depth} -- for source file #{Ddr::Utils.file_path(source)}"
        end
      end

      private

      def run_generator(source_to_use)
        command = "vips im_vips2tiff #{Ddr::Utils.file_path(source_to_use)} #{Ddr::Utils.file_path(output)}:#{options}"
        out, err, s = Open3.capture3(command)
        GeneratorResult.new(out, err, s)
      end

      def make_8_bit(tempdir)
        temp_8_bit = File.new(File.join(tempdir, "temp_8_bit.v"), 'wb')
        command = "vips im_msb #{Ddr::Utils.file_path(source)} #{Ddr::Utils::file_path(temp_8_bit)}"
        out, err, s = Open3.capture3(command)
        if s.success?
          return temp_8_bit
        else
          raise Ddr::Models::DerivativeGenerationFailure,
                  "Error converting #{Ddr::Utils.file_path(source)} to 8-bit: #{err}"
        end
      end

      def source_depth
        `identify -format '%[depth]' #{Ddr::Utils.file_path(source)}`
      end

    end
  end
end