module Ddr::Models
  RSpec.describe Contact do

    describe ".call" do
      subject { described_class.call(slug) }
      let(:slug) { 'abc' }

      before do
        allow(described_class).to receive(:get).with(:find, slug: slug) do
          described_class.new(
              "id"=>1, "slug"=>"abc", "name"=>"A, B, and C Services", "short_name"=>"ABCS",
              "url"=>"http://library.inst.edu/abc", "phone"=>"555-1234", "email"=>"abc@library.inst.edu",
              "ask"=>"http://library.inst.edu/abc-ask", "created_at"=>"2015-09-15T16:15:58.514Z",
              "updated_at"=>"2015-09-15T16:15:58.514Z")
        end
      end

      its(:to_s) { is_expected.to eq("A, B, and C Services") }
    end

  end
end
