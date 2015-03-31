FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Group#{n}" }

    initialize_with { Ddr::Auth::Group.build(name) }
  end
end
