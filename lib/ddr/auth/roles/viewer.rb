module Ddr
  module Auth
    module Roles

      class Viewer < Role
        configure type: Ddr::Vocab::Roles.Viewer

        has_permission :read
      end

    end
  end
end
