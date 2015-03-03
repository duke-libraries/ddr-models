# 
# An Item is a  member of a Collection -- i.e., a "work" -- the principal describable resource.
#
# Examples: photograph, book, article, sound recording, video, etc.
#
class Item < Ddr::Models::Base
  
  include Ddr::Models::HasChildren

  has_many :children, property: :is_part_of, class_name: 'Component'
  belongs_to :parent, property: :is_member_of_collection, class_name: 'Collection'

  alias_method :components, :children
  alias_method :component_ids, :child_ids

  alias_method :parts, :children
  alias_method :part_ids, :child_ids

  alias_method :collection, :parent
  alias_method :collection_id, :parent_id
  alias_method :collection=, :parent=

  def children_by_file_use
    file_uses = {}
    sort_key = "#{Ddr::IndexFields::FILE_USE} ASC, #{Ddr::IndexFields::ORDER} ASC"
    results = ActiveFedora::SolrService.query(association_query(:children), rows: 999999, sort: sort_key)
    objs = ActiveFedora::SolrService.lazy_reify_solr_results(results)
    objs.each do |obj|
      file_uses[obj.file_use] ||= []
      file_uses[obj.file_use] << obj
    end
    file_uses
  end

end
