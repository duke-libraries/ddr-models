RSpec.shared_examples "a DDR model" do
  it_behaves_like "a describable object"
  it_behaves_like "a governable object"
  it_behaves_like "a licensable object"
  it_behaves_like "an access controllable object"
  it_behaves_like "an object that has properties"
  it_behaves_like "an object that has a display title"
end
