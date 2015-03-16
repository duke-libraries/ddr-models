require 'spec_helper'

module Ddr
  module Models
    RSpec.describe SolrDocument, type: :model do

      describe "#principal_has_role?" do
        let(:document) { ::SolrDocument.new("admin_metadata__role_ssim"=>[ "inst.faculty", "inst.staff", "inst.student" ]) }
        context "user does not have role" do
          it "should return false" do
            expect(document.principal_has_role?([ "registered" ], "role")).to be false
          end
        end
        context "user does have role" do
          it "should return true" do
            expect(document.principal_has_role?([ "inst.staff" ], "role")).to be true
          end
        end
      end

    end
  end
end