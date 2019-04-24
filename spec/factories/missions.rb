# frozen_string_literal: true

FactoryBot.define do
  factory :mission do
    name { Faker::Company.bs }
    description { Faker::Lorem.paragraph }
    max_member_count { rand(4..8) }
    min_member_count { rand(1..3) }
    due_date { Faker::Time.forward(rand(30)) }
    author { create(:member) }
  end
end
