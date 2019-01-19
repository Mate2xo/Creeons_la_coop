# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    street_name_1 { Faker::Address.street_name }
    coordonnee { "{lat: #{Faker::Address.latitude}, lng: #{Faker::Address.latitude}}" }
  end
end
