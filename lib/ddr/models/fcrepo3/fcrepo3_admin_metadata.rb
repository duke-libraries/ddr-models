require "rdf/ntriples"

module Ddr::Models
  class Fcrepo3AdminMetadata

    attr_reader :source

    # @param f3_datastream [Rubydora::Datastream] the Fcrepo3 source datastream
    def initialize(f3_datastream)
      @source = f3_datastream
    end

    def subject
      RDF::URI("info:fedora/#{source.pid}")
    end

    def f3_graph
      RDF::Graph.new.from_ntriples(source.content)
    end

    def f4_graph
      graph = f3_graph
      graph.insert f4_role_statement(graph)
      graph.delete *f3_role_statements
      graph
    end

    def f3_role_statements
      [[nil, Ddr::Vocab::Roles.hasRole, nil],
       [nil, RDF.type, Ddr::Vocab::Roles.Role],
       [nil, Ddr::Vocab::Roles.type, nil],
       [nil, Ddr::Vocab::Roles.agent, nil],
       [nil, Ddr::Vocab::Roles.scope, nil]]
    end

    def f4_role_statement(graph)
      role_set = Ddr::Auth::Roles::RoleSet.new
      graph.query(f3_role_query) do |solution|
        role_set << Ddr::Auth::Roles::Role.new(solution.to_hash)
      end
      [subject, Ddr::Vocab::Roles.roleSet, role_set.to_json]
    end

    def f3_role_query
      RDF::Query.new(
        { role: {
            RDF.type => Ddr::Vocab::Roles.Role,
            Ddr::Vocab::Roles.type => :role_type,
            Ddr::Vocab::Roles.agent => :agent,
            Ddr::Vocab::Roles.scope => :scope,
          }
        }
      )
    end

  end
end
