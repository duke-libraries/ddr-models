FactoryGirl.define do

  factory :ability, class: Ddr::Auth::AbstractAbility do
    association :user, factory: :user, strategy: :build
    env Hash.new

    initialize_with { Ddr::Auth::AbilityFactory.call(user, env) }
  end

end
