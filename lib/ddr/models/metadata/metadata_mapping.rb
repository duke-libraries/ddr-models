module Ddr::Models
  class MetadataMapping < SimpleDelegator

    class << self
      def build(vocab, label=nil)
        mapping = vocab.terms.each_with_object({}) do |term, memo|
          memo[term.qualified_name] = term
        end
        new(mapping, label)
      end

      def dc11
        @dc11 ||= build(MetadataVocabulary.dc11, "DC Elements").freeze
      end

      def dcterms
        @dcterms ||= build(MetadataVocabulary.dcterms, "DC Terms").freeze
      end

      def duketerms
        @duketerms ||= build(MetadataVocabulary.duketerms, "Duke Terms").freeze
      end
    end

    attr_accessor :label

    def initialize(mapping=Hash.new, label=nil)
      super(mapping)
      @label = label
    end

    def terms
      values
    end

    def unqualified_names
      terms.map(&:unqualified_name)
    end

    def merge(other)
      MetadataMapping.new(__getobj__.merge(other))
    end

  end
end
