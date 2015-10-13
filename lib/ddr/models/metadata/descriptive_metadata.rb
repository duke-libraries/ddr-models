require "forwardable"

module Ddr::Models
  class DescriptiveMetadata
    extend Forwardable
    include Metadata

    class << self
      def mappers
        [ MetadataMapper.dcterms, MetadataMapper.duketerms ]
      end

      def mapper
        @mapper ||= mappers.reduce(&:merge)
      end

      def mapping
        mapper.mapping
      end

      def unqualified_names
        mapper.unqualified_names
      end

      def field_names
        mapping.keys
      end
      alias_method :field_readers, :field_names

      def field_writers
        field_names.map { |name| "#{name}=".to_sym }
      end
    end

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
