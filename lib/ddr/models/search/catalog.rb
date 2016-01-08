module Ddr::Models
  #
  # Blacklight CatalogController mixin that applies
  # gated discovery.
  #
  # Assumes that the search builder class includes
  # `Ddr::Models::SearchBuilder`.
  #
  module Catalog

    def self.included(controller)
      controller.search_params_logic += [:apply_gated_discovery]

      controller.before_filter :enforce_show_permissions, only: :show
    end

    # @note Originally copied from Hydra::AccessControlsEnforcement
    #   and overridden.
    def enforce_show_permissions
      authorize! :read, params[:id]
    end

  end
end
