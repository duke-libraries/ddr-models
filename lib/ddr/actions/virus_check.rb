require "open3"
require "ostruct"
require "shellwords"

module Ddr::Actions
  class VirusCheck

    # Virus check errors
    class Error < Ddr::Models::Error; end

    # Virus found
    class VirusFound < Error; end

    # Virus scanner error
    class ScannerError < Error; end

    # Virus scanner software not found
    class ScannerNotFound < Error; end

    SCANNER = "clamdscan"

    class << self

      def call(file_path)
        unless File.exist?(file_path)
          raise Error, "File not found: #{file_path}"
        end

        result = OpenStruct.new
        result.event_date_time = Time.now.utc
        begin
          output, status = scan(file_path)
        rescue Errno::ENOENT
          exc = ScannerNotFound.new "Scanner `#{SCANNER}` not found on path."
          logger.error exc
          result.exception = exc
        else
          case status.exitstatus
          when 1
            raise VirusFound, output
          when 2
            exc = ScannerError.new output
            logger.error exc
            result.exception = exc
          end
          result.software = version
          result.detail = output
        end
        result.to_h
      end

      def version
        Open3.capture2(SCANNER, "-V").first.strip
      end

      def scan(path)
        safe_path = Shellwords.shellescape(path)
        Open3.capture2e(SCANNER, safe_path)
      end

      def logger
        Rails.logger
      end

    end

  end
end
