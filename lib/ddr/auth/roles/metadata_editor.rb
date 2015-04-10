module Ddr
  module Auth
    module Roles

      class MetadataEditor < Role
        configure type: Ddr::Vocab::Roles.MetadataEditor

        has_permission :read, :download, :edit
      end

    end
  end
end
