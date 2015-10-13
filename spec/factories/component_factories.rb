FactoryGirl.define do

  factory :component do
    dc_title [ "Test Component" ]
    sequence(:dc_identifier) { |n| [ "cmp%05d" % n ] }
    after(:build) do |c|
      c.upload File.new(File.join(Ddr::Models::Engine.root.to_s, "spec", "fixtures", "imageA.tif"))
    end
  end
end
