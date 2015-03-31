module Ddr
  module Auth
    module Roles

      class Downloader < Role
        configure type: Ddr::Vocab::Roles.Downloader

        has_permission :read, :download
      end

    end
  end
end
