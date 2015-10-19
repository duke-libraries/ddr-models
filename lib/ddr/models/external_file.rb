require 'uri'

module Ddr::Models
  class ExternalFile < ActiveFedora::Base

    belongs_to :component, predicate: Ddr::Vocab::Asset.isExternalFileFor, class_name: "Component"

    property :use, predicate: Ddr::Vocab::Asset.use, multiple: false
    property :location, predicate: Ddr::Vocab::Asset.location, multiple: false
    property :mime_type, predicate: ::RDF::DC.format, multiple: false
    property :resource_type, predicate: ::RDF::DC.type, multiple: false

    # TODO - validation?

    # Cf. https://github.com/projecthydra/active_fedora/issues/914
    # for why we're using before_save instead of before_validation
    before_save :set_mime_type, unless: "mime_type.present?"

    def location= loc
      u = URI(loc)
      if u.scheme.nil?
        u.scheme = 'file'
      end
      super(u.to_s)
    end

    def file_path
      URI.parse(location).path
    end

    private

    def set_mime_type
      self.mime_type = Ddr::Utils.mime_type_for(file_path)
    end

  end
end
