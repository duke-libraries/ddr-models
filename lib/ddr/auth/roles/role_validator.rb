module Ddr::Auth
  class RoleValidator < Ddr::Models::Validator

    validates :agent, presence: true
    validates :role_type, inclusion: { in: Roles.type_map.keys }
    validates :scope, inclusion: { in: Roles::SCOPES }

  end
end
