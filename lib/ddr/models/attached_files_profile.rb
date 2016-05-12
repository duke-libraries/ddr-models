module Ddr::Models
  class AttachedFilesProfile
    include ActiveModel::Serializers::JSON

    attr_reader :object

    def initialize(object)
      @object = object
    end

    def attributes
      files.keys.map { |k| [k, nil] }.to_h
    end

    def read_attribute_for_serialization(key)
      AttachedFileProfile.new(files[key])
    end

    private

    def files
      object.attached_files_having_content
    end

  end
end
