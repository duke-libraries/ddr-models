module Ddr
  module Managers
    extend ActiveSupport::Autoload

    autoload :Manager
    autoload :DerivativesManager
    autoload :PermanentIdManager
    autoload :RoleManager
    autoload :WorkflowManager

  end
end
