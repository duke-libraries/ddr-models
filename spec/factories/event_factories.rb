FactoryGirl.define do

  factory :event, class: Ddr::Events::Event do
    sequence(:pid) { |n| "test:#{n}"}
  end

end
