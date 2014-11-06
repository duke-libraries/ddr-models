require 'spec_helper'
require 'cancan/matchers'

module Ddr
  module Auth
    RSpec.describe Superuser, type: :model, abilities: true do
      subject { described_class.new }
      it "should be able to manage all" do
        expect(subject).to be_able_to(:manage, :all)
      end
    end
  end
end
