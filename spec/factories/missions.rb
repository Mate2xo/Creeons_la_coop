# frozen_string_literal: true

FactoryBot.define do
  factory :mission do
    name { Faker::Company.bs }
    description { Faker::Lorem.paragraph }
    due_date { Faker::Time.forward(rand(30)) }
    author { create(:member) }
  end
end
