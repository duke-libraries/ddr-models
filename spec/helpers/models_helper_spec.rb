require 'spec_helper'

RSpec.describe ModelsHelper, type: :helper do

  describe 'admin_set_full_name' do
    it "should call I18n to translate the slug" do
      expect(I18n).to receive(:t).with('ddr.admin_set.foo')
      helper.admin_set_full_name('foo')
    end
  end
end