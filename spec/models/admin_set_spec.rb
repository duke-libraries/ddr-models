module Ddr::Models
  RSpec.describe AdminSet do

    describe ".call" do
      subject { described_class.call(obj) }

      describe "when the object has an admin set" do
        let(:obj) { double(admin_set: "dvs") }
        before do
          allow(described_class).to receive(:find).with(code: "dvs") do
            described_class.new("id"=>1, "code"=>"dvs", "title"=>"Data and Visualization Services", "created_at"=>"2015-09-15T16:15:58.514Z", "updated_at"=>"2015-09-15T16:15:58.514Z")
          end
        end

        its(:to_s) { is_expected.to eq("Data and Visualization Services") }
      end

      describe "when the object does not have an admin set" do
        let(:obj) { double(admin_set: nil) }
        it { is_expected.to be_nil }
      end
    end

  end
end
