# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id            :bigint(8)        not null, primary key
#  postal_code   :string
#  city          :string           not null
#  street_name_1 :string
#  street_name_2 :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  productor_id  :bigint(8)
#  member_id     :bigint(8)
#  coordonnee    :string
#

FactoryBot.define do
  factory :address do
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    street_name_1 { Faker::Address.street_name }

    trait :coordinates do
      coordinates { [Faker::Address.latitude, Faker::Address.longitude] }
    end

    trait :for_productor do
      productor
    end

    trait :for_member do
      member
    end

    trait :for_missions do
      transient do
        missions_count { 2 }
      end
      after(:create) do |address, evaluator|
        create_list(:mission, evaluator.missions_count, addresses: [address])
      end
      # association :missions, factory: :mission
    end

    factory :productor_address, traits: [:for_productor]
    factory :member_address, traits: [:for_member]
    factory :missions_address, traits: [:for_missions]
  end
end
