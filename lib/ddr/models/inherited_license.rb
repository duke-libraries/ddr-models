module Ddr::Models
  class InheritedLicense

    def self.call(obj)
      if obj.respond_to?(:parent) && obj.parent
        EffectiveLicense.call obj.parent
      elsif obj.admin_policy && (obj.admin_policy != obj)
        EffectiveLicense.call obj.admin_policy
      end
    end

  end
end
