module Ddr::Actions
  class VirusCheck

    # @return [Hash] result data
    # @raises [Ddr::Antivirus::VirusFoundError]
    def self.call(file_path)
      Hash.new.tap do |result|
        begin
          scan_result = Ddr::Antivirus.scan(file_path)
        rescue Ddr::Antivirus::ScannerError => e
          result[:exception] = [e.class.name, e.to_s]
          scan_result = e.result
        end
        result[:event_date_time] = scan_result.scanned_at
        result[:software]        = scan_result.version
        result[:detail]          = scan_result.output
      end
    end

  end
end
