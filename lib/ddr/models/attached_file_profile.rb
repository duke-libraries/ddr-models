require "delegate"

module Ddr::Models
  class AttachedFileProfile < SimpleDelegator
    include ActiveModel::Serializers::JSON

    def attributes
      { "size" => nil, "mime_type" => nil }
    end

  end
end
