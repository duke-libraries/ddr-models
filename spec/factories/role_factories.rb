FactoryGirl.define do

  factory :role, class: Ddr::Auth::Roles::Role do

    initialize_with { Ddr::Auth::Roles::Role.build(attributes) }

    Ddr::Auth::Roles.role_types.each do |rt|
      trait rt.to_s.downcase.to_sym do
        role_type rt.to_s
      end
    end

    trait :person do
      sequence(:agent) { |n| "person#{n}@example.com" }
    end

    trait :group do
      sequence(:agent) { |n| "Group#{n}" }
    end

    trait :public do
      agent Ddr::Auth::Groups::PUBLIC
    end

    Ddr::Auth::Roles::SCOPES.each do |s|
      trait s.to_sym do
        scope s
      end
    end

  end
end
