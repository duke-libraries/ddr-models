FactoryGirl.define do

  factory :collection do
    dc_title [ "Test Collection" ]
    sequence(:dc_identifier) { |n| [ "coll%05d" % n ] }
  end

end
