require "forwardable"

module Ddr::Models
  class DescriptiveMetadata
    extend Forwardable

    class << self
      attr_accessor :rdf_vocabs

      def mappers
        @mappers ||= rdf_vocabs.map { |rdf_vocab| MetadataMapper.new(rdf_vocab) }
      end

      def mapping
        @mapping ||= mappers.map(&:mapping).reduce(&:merge)
      end

      def field_names
        mapping.keys
      end
      alias_method :field_readers, :field_names

      def field_writers
        field_names.map { |name| "#{name}=".to_sym }
      end
    end

    self.rdf_vocabs = [RDF::DC, Ddr::Vocab::DukeTerms].freeze

    attr_reader :object

    def_delegators :object, *field_readers
    def_delegators :object, *field_writers

    mapping.each do |name, term|
      def_delegator :object, name, term.unqualified_name
      def_delegator :object, "#{name}=".to_sym, "#{term.unqualified_name}=".to_sym
    end

    def initialize(object)
      @object = object
    end

  end
end
