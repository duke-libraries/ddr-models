module Ddr::Models
  class AttachedFilesProfile
    include ActiveModel::Serializers::JSON

    attr_reader :files_hash

    # @param files_hash [ActiveFedora::FilesHash]
    def initialize(files_hash)
      @files_hash = files_hash
    end

    def attributes
      files_hash.keys.each_with_object({}) do |key, memo|
        unless files_hash[key].destroyed?
          memo[key.to_s] = nil
        end
      end
    end

    def read_attribute_for_serialization(key)
      AttachedFileProfile.new(files_hash[key])
    end

  end
end
