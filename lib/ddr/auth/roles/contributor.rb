module Ddr
  module Auth
    module Roles

      class Contributor < Role
        configure type: Ddr::Vocab::Roles.Contributor

        has_permission :read, :add_children
      end

    end
  end
end
