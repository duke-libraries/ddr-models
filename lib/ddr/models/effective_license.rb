module Ddr::Models
  class EffectiveLicense

    def self.call(obj)
      License.call(obj) || InheritedLicense.call(obj)
    end

  end
end
