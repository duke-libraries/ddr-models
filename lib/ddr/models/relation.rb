module Ddr::Models
  #
  # Since ActiveFedora does not yet (as of at least v9.9.1)
  # have named scopes, this module extends Base and is
  # included in AF::Relation for chainability.
  #
  module Relation
    def having_local_id(local_id)
      where(Ddr::Index::Fields::LOCAL_ID => local_id)
    end

    def in_collection(coll)
      where(Ddr::Index::Fields::IS_MEMBER_OF_COLLECTION => coll.respond_to?(:id) ? coll.id : coll)
    end
  end
end

ActiveFedora::Relation.include(Ddr::Models::Relation)
