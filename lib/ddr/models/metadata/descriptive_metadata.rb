require "forwardable"

module Ddr::Models
  class DescriptiveMetadata
    extend Forwardable
    include Metadata

    class_attribute :mappings

    class << self
      def mapping
        @mapping ||= mappings.reduce(&:merge)
      end

      def unqualified_names
        mapping.unqualified_names
      end

      def field_names
        mapping.keys
      end
      alias_method :field_readers, :field_names

      def field_writers
        field_names.map { |name| "#{name}=".to_sym }
      end
    end

    self.mappings = [ MetadataMapping.dcterms, MetadataMapping.duketerms ].freeze

    attr_reader :object

    def_delegators :object, *field_readers
    def_delegators :object, *field_writers

    mapping.each do |qualified_name, term|
      def_delegator :object, qualified_name, term.unqualified_name
      def_delegator :object, "#{qualified_name}=".to_sym, "#{term.unqualified_name}=".to_sym
    end

    def initialize(object)
      @object = object
    end

  end
end
