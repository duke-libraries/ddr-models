module Ddr::Models
  module Versionable

    # Override AF::Versionable
    # @example
    #   => "version.20160205153424.643252000"
    def version_name
      "version.#{Time.now.utc.strftime('%Y%m%d%H%M%S.%N')}"
    end

  end
end
