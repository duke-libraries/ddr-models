module Ddr::Models
  class ParentLicense

    def self.call(obj)
      if obj.respond_to?(:parent) && obj.parent
        License.call(obj.parent)
      end
    end

  end
end
