# frozen_string_literal: true

FactoryBot.define do
  factory :info do
    content { Faker::Lorem.paragraph(3) }
    title { Faker::Movie.quote }
    author { create(:member) }
  end
end
