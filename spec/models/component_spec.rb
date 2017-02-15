RSpec.describe Component, type: :model, components: true do

  it_behaves_like "a DDR model"
  it_behaves_like "an object that can have content"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_part_of, "Item"
  it_behaves_like "it has an association", :belongs_to, :target, :has_external_target, "Target"
  it_behaves_like "a non-collection model"
  it_behaves_like "a potentially publishable object"
  it_behaves_like "an object that can have an intermediate file"

  describe "indexing" do
    subject { FactoryGirl.build(:component) }
    before do
      allow(subject).to receive(:collection) { Collection.new(pid: "test:1") }
    end
    its(:index_fields) { is_expected.to include(Ddr::Index::Fields::COLLECTION_URI => "info:fedora/test:1") }
  end

  describe "default structure" do
    describe "no content" do
      it "should be nil" do
        expect(subject.default_structure).to be_nil
      end
    end
    describe "has content" do
      before { allow(subject).to receive(:has_content?) { true } }
      before { allow(subject).to receive(:has_thumbnail?) { true } }
      let(:struct) { subject.default_structure }
      it "has the correct original file" do
        expect(struct.uses[Ddr::Models::Structure::USE_ORIGINAL_FILE].first.href).to eq(Ddr::Datastreams::CONTENT )
      end
      it "has the correct preservation master file" do
        expect(struct.uses[Ddr::Models::Structure::USE_PRESERVATION_MASTER_FILE].first.href)
                                                                                  .to eq(Ddr::Datastreams::CONTENT )
      end
      describe "service file" do
        describe "with multires image" do
          before do
            allow(subject).to receive(:has_multires_image?) { true }
          end
          it "has the correct structure file" do
            expect(struct.uses[Ddr::Models::Structure::USE_SERVICE_FILE].first.href)
                                                                            .to eq(Ddr::Datastreams::MULTIRES_IMAGE )
          end
        end
        describe "without multires image" do
          it "has the correct structure file" do
            expect(struct.uses[Ddr::Models::Structure::USE_SERVICE_FILE].first.href).to eq(Ddr::Datastreams::CONTENT )
          end
        end
      end
      it "has the correct thumbnail image" do
        expect(struct.uses[Ddr::Models::Structure::USE_THUMBNAIL_IMAGE].first.href).to eq(Ddr::Datastreams::THUMBNAIL )
      end
    end

  end
end
