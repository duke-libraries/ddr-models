module Ddr
  module Auth
    module Roles

      class Owner < Role
        configure type: Ddr::Vocab::Roles.Owner

        has_permission :read, :download, :add_children, :edit, :upload, :arrange, :grant
      end

    end
  end
end
