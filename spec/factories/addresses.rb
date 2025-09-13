# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id            :bigint           not null, primary key
#  city          :string           not null
#  coordinates   :float            is an Array
#  postal_code   :string
#  street_name_1 :string
#  street_name_2 :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  member_id     :bigint
#  productor_id  :bigint
#
# Indexes
#
#  index_addresses_on_member_id     (member_id)
#  index_addresses_on_productor_id  (productor_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (productor_id => productors.id)
#

FactoryBot.define do
  factory :address do
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    street_name_1 { Faker::Address.street_name }

    trait :coordinates do
      coordinates { [rand(49.0..50), rand(2.0..3)] }
    end

    trait :for_productor do
      productor
    end

    trait :for_member do
      member
    end

    trait :for_missions do
      transient { missions_count { 2 } }

      after(:create) do |address, evaluator|
        create_list(:mission, evaluator.missions_count, addresses: [address])
      end
    end

    factory :productor_address, traits: [:for_productor]
    factory :member_address, traits: [:for_member]
    factory :missions_address, traits: [:for_missions]
  end
end
