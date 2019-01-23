# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    street_name_1 { Faker::Address.street_name }
    coordonnee { "{lat: #{Faker::Address.latitude}, lng: #{Faker::Address.latitude}}" }

    trait :for_productor do
      productor
    end

    trait :for_member do
      member
    end

    trait :for_missions do
<<<<<<< HEAD
      transient do
        missions_count {2}
      end
      after(:create) do |address, evaluator|
        create_list(:mission, evaluator.missions_count, addresses: [address])
      end
      # association :missions, factory: :mission
=======
      association :mission, factory: :mission
>>>>>>> 4c865edb1fa2bc352c01ea23de9f12701c95cba1
    end

    factory :productor_address, traits: [:for_productor]
    factory :member_address, traits: [:for_member]
    factory :missions_address, traits: [:for_missions]
  end
end
