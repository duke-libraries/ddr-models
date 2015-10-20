require 'open3'

module Ddr
  module Derivatives
    class PtifGenerator < Generator

      def self.output_mime_type
        "image/tiff"
      end

      def self.output_extension
        "ptif"
      end

      def generate(source_path, output_path)
        case source_depth(source_path).strip
        when '16'
          Dir.mktmpdir do |dir|
            temp_8_bit_path = make_8_bit(dir, source_path)
            run_generator(temp_8_bit_path, output_path)
          end
        when '8'
          run_generator(source_path, output_path)
        else
          raise Ddr::Models::DerivativeGenerationFailure,
                  "Unexpected depth -- #{source_depth} -- for source file #{Ddr::Utils.file_path(source_path)}"
        end
      end

      private

      def run_generator(source_to_use, output_path)
        command = "vips im_vips2tiff #{source_to_use} #{output_path}:#{options}"
        out, err, s = Open3.capture3(command)
        GeneratorResult.new(output_path, out, err, s)
      end

      def make_8_bit(tempdir, source_path)
        temp_8_bit_path = File.join(tempdir, "temp_8_bit.v")
        command = "vips im_msb #{source_path} #{temp_8_bit_path}"
        out, err, s = Open3.capture3(command)
        if s.success?
          return temp_8_bit_path
        else
          raise Ddr::Models::DerivativeGenerationFailure,
                  "Error converting #{source_path} to 8-bit: #{err}"
        end
      end

      def source_depth(source_path)
        `identify -format '%[depth]' #{source_path}`
      end

    end
  end
end
