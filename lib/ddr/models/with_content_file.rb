require "tempfile"
require "delegate"

module Ddr::Models
  class WithContentFile < SimpleDelegator

    def initialize(obj, &block)
      super(obj)
      with_temp_file &block
    end

    # Yields path of tempfile containing content to block
    # @yield [String] the path to the tempfile containing content
    def with_temp_file
      filename = original_filename || content.default_file_name
      basename = [ File.basename(filename, ".*"), File.extname(filename) ]
      infile = Tempfile.open(basename, Ddr::Models.tempdir, encoding: 'ascii-8bit')
      begin
        infile.write(content.content)
        infile.close
        verify_checksum!(infile)
        yield infile.path
      ensure
        infile.close unless infile.closed?
        File.unlink(infile)
      end
    end

    def verify_checksum!(file)
      digest = Ddr::Utils.digest(File.read(file), content.checksum.algorithm)
      if digest != content.checksum.value
        raise ChecksumInvalid, "The checksum of the downloaded file does not match the stored checksum of the content."
      end
    end

  end
end
