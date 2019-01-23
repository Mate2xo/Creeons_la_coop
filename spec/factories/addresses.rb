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
      association :mission, factory: :mission
    end

    factory :productor_address, traits: [:for_productor]
    factory :member_address, traits: [:for_member]
    factory :missions_address, traits: [:for_missions]
  end
end
