require 'spec_helper'

RSpec.describe Attachment, type: :model, attachments: true do

  it_behaves_like "a DDR model"
  it_behaves_like "an object that can have content"
  it_behaves_like "a non-collection model"

end
