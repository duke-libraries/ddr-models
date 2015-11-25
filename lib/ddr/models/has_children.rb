module Ddr
  module Models
    module HasChildren

      def first_child
        child_class = self.class.reflect_on_association(:children).klass
        if has_struct_metadata?
          child_class.find(structure.default_struct_map_ids.first)
        else
          solr_field = child_class.reflect_on_association(:parent).solr_key
          child_class.where(solr_field => id).order("#{Ddr::Index::Fields::LOCAL_ID} ASC").first
        end
      end

    end
  end
end
