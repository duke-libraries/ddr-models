module Ddr::Models
  class EffectiveLicense

    def self.call(obj)
      if obj.license
        License.get(obj.license)
      elsif obj.respond_to?(:parent) && obj.parent
        call(obj.parent)
      elsif obj.admin_policy && (obj.admin_policy != obj)
        call(obj.admin_policy)
      end
    end

  end
end
