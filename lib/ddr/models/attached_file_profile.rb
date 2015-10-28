require "delegate"

module Ddr::Models
  class AttachedFileProfile < SimpleDelegator
    include ActiveModel::Serializers::JSON

    def attributes
      { "size" => nil }
    end

  end
end
