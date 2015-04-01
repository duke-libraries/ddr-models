FactoryGirl.define do
  factory :group, class: Ddr::Auth::Group do
    sequence(:name) { |n| "Group#{n}" }

    initialize_with { Ddr::Auth::Group.build(name) }
  end
end
