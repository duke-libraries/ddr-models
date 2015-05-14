module Ddr
  module Managers
    extend ActiveSupport::Autoload

    autoload :Manager
    autoload :DerivativesManager
    autoload :PermanentIdManager
    autoload :WorkflowManager

  end
end
