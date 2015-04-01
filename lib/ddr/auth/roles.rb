module Ddr
  module Auth
    module Roles
      extend ActiveSupport::Autoload

      autoload :Role
      autoload :RoleSet
      autoload :Query

      autoload :Curator
      autoload :Editor
      autoload :MetadataEditor
      autoload :Contributor
      autoload :Downloader
      autoload :Viewer

      class << self
        # Return the class for a type of role specified as a symbol or string
        # @example
        #   get_role_class(:curator) 
        #   => Ddr::Auth::Roles::Curator
        # @param role_type [Symbol, String] the role type
        # @return [Class] the role class
        def get_role_class(role_type)
          role_class = const_get(role_type.to_s.camelize)
          unless role_class < Role
            raise ArgumentError, "#{role_type.inspect} is not a valid role type."
          end
          role_class
        end
        alias_method :get, :get_role_class

        # Builds a new role instance by type and a hash of arguments
        # @param args [Hash] the role arguments
        # @return [Ddr::Auth::Roles::Role] the role instance
        # @see .get_role_class
        # @see Ddr::Auth::Roles::Role.build
        def build_role(args={})
          role_type = args.delete(:type)
          get_role_class(role_type).build(args)
        end

        # Return the RDF term for the scope
        # @param scope [Symbol, String] the scope
        # @return [RDF::Vocabulary::Term] the scope term
        # @example 
        #   get_scope_term(:resource) 
        #   => #<RDF::Vocabulary::Term:0x3fee2204d10c URI:http://repository.lib.duke.edu/vocab/scopes/Resource>
        def get_scope_term(scope)
          Ddr::Vocab::Scopes.send(scope.to_s.capitalize)
        end
      end

    end
  end
end
