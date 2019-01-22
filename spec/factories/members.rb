# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    biography { Faker::ChuckNorris.fact }
    phone_number { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email(first_name) }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.zone.today }
  end
end
