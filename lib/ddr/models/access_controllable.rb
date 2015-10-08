module Ddr
  module Models
    module AccessControllable
      extend ActiveSupport::Concern

      included do
        include Hydra::AccessControls::Permissions
      end

    end
  end
end
