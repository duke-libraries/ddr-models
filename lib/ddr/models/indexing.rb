module Ddr
  module Models
    module Indexing
      extend ActiveSupport::Concern

      included do
        class_attribute :indexes
        self.indexes = {}

        def self.index_name(key)
          indexes[key].name
        end
        
        def self.index(key, *args, &block)
          name = ActiveFedora::SolrService.solr_name(key, *args)
          method = block || key
          idx = Index.new(name, method)
          self.indexes = indexes.merge(key => idx)
        end
        
        index :title, :stored_sortable do
          title_display 
        end

        index :identifier, :stored_sortable do
          identifier_sort
        end
      end

      def index_value(key)
        indexes[key].value(self)
      end

      def index_fields
        indexes.values.each_with_object({}) do |idx, doc|
          doc[idx.name] = idx.value(self)
        end
      end

      def to_solr(solr_doc=Hash.new, opts={})
        super(solr_doc, opts).merge(index_fields)
      end

      def title_display
        return title.first if title.present?
        return identifier.first if identifier.present?
        return original_filename if respond_to?(:original_filename) && original_filename.present?
        "[#{pid}]"
      end

      def identifier_sort
        identifier.first
      end

    end
  end
end
