require 'spec_helper'

RSpec.describe Item, :type => :model do
  it_behaves_like "a DDR model"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_member_of_collection, "Collection"
  it_behaves_like "it has an association", :has_many, :children, :is_part_of, "Component"

end
