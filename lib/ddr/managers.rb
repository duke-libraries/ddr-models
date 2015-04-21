module Ddr
  module Managers
    extend ActiveSupport::Autoload

    autoload :Manager
    autoload :AbstractRoleManager
    autoload :DerivativesManager
    autoload :PermanentIdManager
    autoload :RoleManager
    autoload :SolrDocumentRoleManager
    autoload :WorkflowManager

  end
end
