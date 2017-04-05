RSpec.shared_examples "an object that can have an intermediate file" do

  subject { described_class.new(title: [ "I Have An Intermediate File!" ]) }

  describe "save" do
    describe "when a new intermediate file is present" do
      context "and it's a new object" do
        before { subject.add_file file, "intermediateFile" }
        let(:file) { fixture_file_upload("imageA.jpg", "image/jpeg") }
        it "should generate derivatives" do
          expect_any_instance_of(Ddr::Managers::DerivativesManager).to receive(:update_derivatives)
          subject.save
        end
      end
      context "and it's an existing object with an intermediate file" do
        before { subject.upload! fixture_file_upload('imageA.jpg', 'image/jpeg') }
        let(:file) { fixture_file_upload("imageB.jpg", "image/jpeg") }
        it "should generate derivatives" do
          expect_any_instance_of(Ddr::Managers::DerivativesManager).to receive(:update_derivatives)
          subject.upload! file
        end
      end
    end
  end

end


