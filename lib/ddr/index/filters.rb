module Ddr::Index
  module Filters

    HAS_CONTENT = Filter.raw(
      "%s:(Component OR Attachment OR Target)" % Fields::ACTIVE_FEDORA_MODEL
    )

    class << self
      def is_governed_by(pid)
        Filter.where Fields::IS_GOVERNED_BY => internal_uri(pid)
      end

      def internal_uri(pid)
        ActiveFedora::Base.internal_uri(pid)
      end
    end

    private_class_method :internal_uri

  end
end
