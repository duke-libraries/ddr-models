module Ddr::Models
  RSpec.describe License, ddr_aux: true do

    describe ".call" do
      describe "when the object has a license URL" do
        let(:obj) { double(id: "test-1", license: "http://example.com") }
        describe "and the license is found" do
          before {
            allow(described_class).to receive(:get).with(:find, url: "http://example.com") {
              {"id"=>1, "url"=>"http://example.com", "title"=>"A License"}
            }
          }
          it "returns a License instance" do
            expect(described_class.call(obj)).to be_a(described_class)
          end
          it "sets `object_id` to the object id" do
            expect(described_class.call(obj).object_id).to eq("test-1")
          end
        end
        describe "and the license is not found" do
          before {
            allow(described_class).to receive(:get).with(:find, url: "http://example.com")
                                       .and_raise(ActiveResource::ResourceNotFound, "404")
          }
          it "raises an exception" do
            expect { described_class.call(obj) }.to raise_error(Ddr::Models::NotFoundError)
          end
        end
      end

      describe "when the object does not have a license" do
        let(:obj) { double(id: "test-1", license: nil) }
        it "returns nil" do
          expect(described_class.call(obj)).to be_nil
        end
      end
    end

    describe ".keys" do
      let(:entries) { [ described_class.new(id: 1, url: 'http://localhost/licenseA', title: 'License A'),
                        described_class.new(id: 2, url: 'http://localhost/licenseB', title: 'License B') ] }
      let(:response_collection) { ActiveResource::Collection.new }
      before do
        response_collection.elements = entries
        allow(described_class).to receive(:all) { response_collection }
      end
      it "returns the defined urls" do
        expect(described_class.keys).to match_array([ entries[0].url, entries[1].url ])
      end
    end

    describe "instance methods" do
      subject { described_class.new("id"=>1, "url"=>"http://example.com", "title"=>"A License") }
      its(:to_s) { is_expected.to eq("A License") }
    end

  end
end
