module Ddr::Models
  RSpec.describe Language, ddr_aux: true do

    describe ".call" do
      let(:obj) { Item.new }

      describe "when the object has a language" do
        before { obj.language = ["cym"] }
        let(:language) {
          described_class.new("id"=>1, "code"=>"cym", "title"=>"Welsh", "created_at"=>"2015-09-15T16:15:58.514Z", "updated_at"=>"2015-09-15T16:15:58.514Z")
        }
        describe "and the language code is found" do
          before {
            allow(described_class).to receive(:find_by_code).with("cym") { language }
          }
          it "returns a Language instance" do
            expect(described_class.call(obj)).to eq([language])
          end
        end
        describe "and the language is not found" do
          before {
            allow(described_class).to receive(:find_by_code).with("cym")
                                       .and_raise(ActiveResource::ResourceNotFound, "404")
          }
          it "raises an exception" do
            expect { described_class.call(obj) }.to raise_error(Ddr::Models::NotFoundError)
          end
        end
      end

      describe "when the object does not have language" do
        it "returns empty array" do
          expect(described_class).not_to receive(:find_by_code)
          expect(described_class.call(obj)).to eq([])
        end
      end
    end


    describe ".codes" do
      let(:entries) { [ described_class.new(id: 1, code: 'cym', label: 'Welsh'),
                        described_class.new(id: 2, code: 'fre', label: 'French') ] }
      let(:response_collection) { ActiveResource::Collection.new }
      before do
        response_collection.elements = entries
        allow(described_class).to receive(:all) { response_collection }
      end
      it "returns the defined codes" do
        expect(described_class.codes).to match_array([ entries[0].code, entries[1].code ])
      end
    end

    describe "instance methods" do
      subject { described_class.new("id"=>1, "code"=>"cym", "label"=>"Welsh") }
      its(:to_s) { is_expected.to eq("Welsh") }
    end

  end
end
