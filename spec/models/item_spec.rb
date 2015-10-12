require 'spec_helper'

RSpec.describe Item, type: :model do

  it_behaves_like "a DDR model"
  it_behaves_like "a non-collection model"

end
