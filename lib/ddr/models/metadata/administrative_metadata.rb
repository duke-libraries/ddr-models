require "forwardable"

module Ddr::Models
  class AdministrativeMetadata
    extend Forwardable
    include Metadata


    class << self
      def field_names
        [ :access_roles,
          :admin_set,
          :aspace_id,
          :depositor,
          :display_format,
          :doi,
          :ead_id,
          :fcrepo3_pid,
          :license,
          :local_id,
          :permanent_id,
          :permanent_url,
          :research_help_contact,
          :workflow_state
        ]
      end

      alias_method :unqualified_names, :field_names
      alias_method :field_readers, :field_names

      def field_writers
        field_names.map { |name| "#{name}=".to_sym }
      end

      def property_terms
        field_names.each_with_object({}) do |term, memo|
          memo[term] = term
        end
      end

    end

    attr_reader :object

    def_delegators :object, *field_readers
    def_delegators :object, *field_writers

    def initialize(object)
      @object = object
    end

  end
end
