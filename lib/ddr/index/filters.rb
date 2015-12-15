module Ddr::Index
  module Filters
    extend Deprecation

    def self.has_content
      Filter.where(Fields::ACTIVE_FEDORA_MODEL => ["Component", "Attachment", "Target"])
    end

    def self.is_governed_by(object_or_id)
      Filter.where(Fields::IS_GOVERNED_BY => internal_uri(object_or_id))
    end

    def self.is_member_of_collection(object_or_id)
      Filter.where(Fields::IS_MEMBER_OF_COLLECTION => internal_uri(object_or_id))
    end

    private

    def self.const_missing(name)
      if name == :HAS_CONTENT
        Deprecation.warn(self,
                         "`Ddr::Index::Filters::#{name}` is deprecated and will be removed in ddr-models 3.0." \
                         " Use `Ddr::Index::Filters.has_content` instead.")
        has_content
      else
        super
      end
    end

    def self.internal_uri(object_or_id)
      if object_or_id.respond_to?(:internal_uri)
        object_or_id.internal_uri
      else
        ActiveFedora::Base.internal_uri(object_or_id)
      end
    end

  end
end
