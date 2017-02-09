module Ddr::Datastreams
  class ExternalDatastream < ActiveFedora::Datastream

    def self.default_attributes
      super.merge(controlGroup: "E")
    end

    class_attribute :file_store

    def self.get_file_store
      file_store || Ddr::Models.external_file_store
    end

  end
end
