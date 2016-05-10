module Ddr::Index
  RSpec.describe CSVQueryResult do

    subject { described_class.new(query) }

    before do
      Item.create(dc_title: ["Testing 1"],
                  dc_identifier: ["test1"],
                  dc_description: ["The process of eliminating errors."])
      Item.create(dc_title: ["Testing 2"],
                  dc_identifier: ["test2"])
      Item.create(dc_title: ["Testing 3"])
    end

    let(:query) {
      Ddr::Index::Query.new do
        fields Ddr::Index::Fields::ID
        fields Ddr::Index::Fields.descmd
      end
    }

    specify {
      expect(subject["dc_title"]).to contain_exactly("Testing 1", "Testing 2", "Testing 3")
      expect(subject["dc_identifier"]).to contain_exactly("test1", "test2", nil)
      expect(subject["dc_description"]).to contain_exactly("The process of eliminating errors.", nil, nil)
      expect(subject["dc_creator"]).to contain_exactly(nil, nil, nil)
      expect(subject.to_s).to match(/dc_creator/)
    }

    describe "#delete_empty_columns!" do
      specify {
        subject.delete_empty_columns!
        expect(subject["dc_title"]).to contain_exactly("Testing 1", "Testing 2", "Testing 3")
        expect(subject["dc_identifier"]).to contain_exactly("test1", "test2", nil)
        expect(subject["dc_description"]).to contain_exactly("The process of eliminating errors.", nil, nil)
        expect(subject["dc_creator"]).to contain_exactly(nil, nil, nil)
        expect(subject.to_s).not_to match(/dc_creator/)
      }
    end

  end
end
