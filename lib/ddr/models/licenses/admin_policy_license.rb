module Ddr::Models
  class AdminPolicyLicense

    def self.call(obj)
      if obj.admin_policy_id && (obj.admin_policy_id != obj.id)
        License.call obj.admin_policy
      end
    end

  end
end
