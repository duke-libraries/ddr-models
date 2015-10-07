module Ddr::Models
  class InheritedLicense

    def self.call(obj)
      ParentLicense.call(obj) || AdminPolicyLicense.call(obj)
    end

  end
end
