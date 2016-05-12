FactoryGirl.define do

  factory :item do
    dc_title [ "Test Item" ]
    sequence(:dc_identifier) { |n| [ "item%05d" % n ] }
  end

end
