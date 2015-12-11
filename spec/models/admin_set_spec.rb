module Ddr::Models
  RSpec.describe AdminSet, ddr_aux: true do

    describe ".call" do
      let(:obj) { Item.new }

      describe "when the object has an admin set" do
        before { obj.admin_set = "dvs" }
        describe "and the admin set code is found" do
          before {
            allow(described_class).to receive(:get).with(:find, code: "dvs") {
              {"id"=>1, "code"=>"dvs", "title"=>"Data and Visualization Services", "created_at"=>"2015-09-15T16:15:58.514Z", "updated_at"=>"2015-09-15T16:15:58.514Z"}
            }
          }
          it "returns an AdminSet instance" do
            expect(described_class.call(obj)).to be_a(described_class)
          end
        end
        describe "and the admin set is not found" do
          before {
            allow(described_class).to receive(:get).with(:find, code: "dvs")
                                       .and_raise(ActiveResource::ResourceNotFound, "404")
          }
          it "raises an exception" do
            expect { described_class.call(obj) }.to raise_error(Ddr::Models::NotFoundError)
          end
        end
      end

      describe "when the object does not have an admin set" do
        it "returns nil" do
          expect(described_class.call(obj)).to be_nil
        end
      end
    end

    describe "instance methods" do
      subject { described_class.new("id"=>1, "code"=>"dvs", "title"=>"Data and Visualization Services", "created_at"=>"2015-09-15T16:15:58.514Z", "updated_at"=>"2015-09-15T16:15:58.514Z") }
      its(:to_s) { is_expected.to eq("Data and Visualization Services") }
    end

  end
end
