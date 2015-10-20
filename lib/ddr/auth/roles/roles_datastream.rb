module Ddr::Auth::Roles
  class RolesDatastream < ActiveFedora::NtriplesRDFDatastream

    property :roles,
             predicate: Ddr::Vocab::Roles.hasRole,
             class_name: Ddr::Auth::Roles::Role

  end
end
