module Ddr
  module Managers
    extend ActiveSupport::Autoload

    autoload :Manager
    autoload :DerivativesManager
    autoload :TechnicalMetadataManager
    autoload :WorkflowManager

  end
end
