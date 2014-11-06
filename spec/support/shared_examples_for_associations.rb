RSpec.shared_examples "it has an association" do |macro, association, property, class_name|
  it "via a certain property" do
    expect(described_class.reflect_on_association(association).options[:property]).to eq property
  end
  it "targeting a certain class name" do
    expect(described_class.reflect_on_association(association).options[:class_name]).to eq class_name
  end
end
