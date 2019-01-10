FactoryBot.define do

  factory :collection do
    title [ "Test Collection" ]
    admin_set "foo"
    sequence(:identifier) { |n| [ "coll%05d" % n ] }
  end

end
