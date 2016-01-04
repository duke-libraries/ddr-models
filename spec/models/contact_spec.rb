module Ddr::Models
  RSpec.describe Contact, ddr_aux: true do

    describe ".call" do
      describe "when the slug is found" do
        before {
          allow(described_class).to receive(:get).with(:find, slug: "abc") {
            {"id"=>1, "slug"=>"abc", "name"=>"A, B, and C Services", "short_name"=>"ABCS",
             "url"=>"http://library.inst.edu/abc", "phone"=>"555-1234", "email"=>"abc@library.inst.edu",
             "ask"=>"http://library.inst.edu/abc-ask", "created_at"=>"2015-09-15T16:15:58.514Z",
             "updated_at"=>"2015-09-15T16:15:58.514Z"}
          }
        }
        it "returns a Contact instance" do
          expect(described_class.call("abc")).to be_a(described_class)
        end
      end
      describe "when the slug is not found" do
        before {
          allow(described_class).to receive(:get).with(:find, slug: "abc")
                                     .and_raise(ActiveResource::ResourceNotFound, "404")
        }
        it "raises an exception" do
          expect { described_class.call("abc") }.to raise_error(Ddr::Models::NotFoundError)
        end
      end
    end

    describe "instance methods" do
      subject {
        described_class.new(
          "id"=>1, "slug"=>"abc", "name"=>"A, B, and C Services", "short_name"=>"ABCS",
          "url"=>"http://library.inst.edu/abc", "phone"=>"555-1234", "email"=>"abc@library.inst.edu",
          "ask"=>"http://library.inst.edu/abc-ask", "created_at"=>"2015-09-15T16:15:58.514Z",
          "updated_at"=>"2015-09-15T16:15:58.514Z"
        )
      }
      its(:to_s) { is_expected.to eq("A, B, and C Services") }
    end

  end
end
