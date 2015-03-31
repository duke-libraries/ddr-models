module Ddr
  module Auth
    module Roles

      class Editor < Role
        configure type: Ddr::Vocab::Roles.Editor

        has_permission :read, :download, :add_children, :edit, :replace, :arrange
      end

    end
  end
end
