module Ddr
  module Managers
    extend ActiveSupport::Autoload

    autoload :Manager
    autoload :PermanentIdManager
    autoload :RoleManager
    autoload :WorkflowManager

  end
end
