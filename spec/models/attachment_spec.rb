require 'spec_helper'

RSpec.describe Attachment, type: :model, attachments: true do
  it_behaves_like "a DDR model"
  it_behaves_like "an object that can have content"
  it_behaves_like "it has an association", :belongs_to, :attached_to, :is_attached_to, "ActiveFedora::Base"
  context "validations" do
    before { subject.valid? }
    it "should have content" do
      expect(subject.errors.messages).to have_key(:content)
    end
  end
end
