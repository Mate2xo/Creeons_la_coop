# frozen_string_literal: true

FactoryBot.define do
  factory :productor do
    name { Faker::Company.name }
    text { Faker::Lorem.paragraph }
    phone_number { Faker::PhoneNumber.phone_number }
    website_url { Faker::Internet.url("#{name}.com") }
  end
end
