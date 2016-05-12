require "delegate"

module Ddr::Models
  class AttachedFileProfile < SimpleDelegator
    include ActiveModel::Serializers::JSON

    def attributes
      { "size"=>nil, "mime_type"=>nil, "sha1"=>nil }
    end

    def sha1
      checksum.value
    end

  end
end
