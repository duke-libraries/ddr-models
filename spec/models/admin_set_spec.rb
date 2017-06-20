module Ddr::Models
  RSpec.describe AdminSet, ddr_aux: true, admin_set: true do

    describe ".call" do
      let(:obj) { Item.new }

      describe "when the object has an admin set" do
        before { obj.admin_set = "dvs" }
        let(:admin_set) {
          described_class.new("id"=>1, "code"=>"dvs", "title"=>"Data and Visualization Services", "created_at"=>"2015-09-15T16:15:58.514Z", "updated_at"=>"2015-09-15T16:15:58.514Z")
        }
        describe "and the admin set code is found" do
          before {
            allow(described_class).to receive(:find_by_code).with("dvs") { admin_set }
          }
          it "returns an AdminSet instance" do
            expect(described_class.call(obj)).to eq(admin_set)
          end
        end
        describe "and the admin set is not found" do
          before {
            allow(described_class).to receive(:find_by_code).with("dvs")
                                       .and_raise(ActiveResource::ResourceNotFound, "404")
          }
          it "raises an exception" do
            expect { described_class.call(obj) }.to raise_error(Ddr::Models::NotFoundError)
          end
        end
      end

      describe "when the object does not have an admin set" do
        it "returns nil" do
          expect(described_class).to receive(:find_by_code).and_call_original
          expect(described_class.call(obj)).to be_nil
        end
      end
    end

    describe ".keys" do
      let(:entries) { [ described_class.new(id: 1, code: 'dvs', title: 'D and V S Department'),
                        described_class.new(id: 2, code: 'abc', title: 'ABC Department') ] }
      let(:response_collection) { ActiveResource::Collection.new }
      before do
        response_collection.elements = entries
        allow(described_class).to receive(:all) { response_collection }
      end
      it "returns the defined codes" do
        expect(described_class.keys).to match_array([ entries[0].code, entries[1].code ])
      end
    end

    describe "instance methods" do
      subject { described_class.new("id"=>1, "code"=>"dvs", "title"=>"Data and Visualization Services", "created_at"=>"2015-09-15T16:15:58.514Z", "updated_at"=>"2015-09-15T16:15:58.514Z") }
      its(:to_s) { is_expected.to eq("Data and Visualization Services") }
    end

  end
end
