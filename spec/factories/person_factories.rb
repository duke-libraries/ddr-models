FactoryGirl.define do
  factory :person, class: Ddr::Auth::Person do
    sequence(:name) { |n| "person#{n}@example.com" }

    initialize_with { Ddr::Auth::Person.build(name) }
  end
end
