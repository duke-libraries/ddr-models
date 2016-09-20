module Ddr::Models
  RSpec.describe ExternalUrl, ddr_aux: true do

    describe ".call" do
      describe "when the url is found" do
        before {
          allow(described_class).to receive(:get).with(:find, url: "http://guides.library.duke.edu/eaa") {
            {"id"=>1, "url"=>"http://guides.library.duke.edu/eaa",
             "title"=>"Emergence of Advertising in America Research Guide",
             "created_at"=>"2015-09-15T16:15:58.514Z", "updated_at"=>"2015-09-15T16:15:58.514Z"}
          }
        }
        it "returns a ExternalUrl instance" do
          expect(described_class.call("http://guides.library.duke.edu/eaa")).to be_a(described_class)
        end
      end
      describe "when the url is not found" do
        before {
          allow(described_class).to receive(:get).with(:find, url: "http://guides.library.duke.edu/foo")
                                     .and_raise(ActiveResource::ResourceNotFound, "404")
        }
        it "raises an exception" do
          expect { described_class.call("http://guides.library.duke.edu/foo") }.to raise_error(Ddr::Models::NotFoundError)
        end
      end
    end

    describe ".keys" do
      let(:entries) { [ described_class.new(id: 1, url: 'http://guides.library.duke.edu/abc', title: 'Guide ABC'),
                        described_class.new(id: 2, url: 'http://guides.library.duke.edu/def', title: 'Guide DEF') ] }
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
      subject {
        described_class.new(
          {"id"=>1, "url"=>"http://guides.library.duke.edu/eaa",
           "title"=>"Emergence of Advertising in America Research Guide",
           "created_at"=>"2015-09-15T16:15:58.514Z", "updated_at"=>"2015-09-15T16:15:58.514Z"}
        )
      }
      its(:to_s) { is_expected.to eq("Emergence of Advertising in America Research Guide") }
    end

  end
end
