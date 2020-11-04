# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                :bigint(8)        not null, primary key
#  name              :string           not null
#  description       :text             not null
#  due_date          :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  author_id         :bigint(8)
#  start_date        :datetime
#  recurrent         :boolean
#  max_member_count  :integer
#  min_member_count  :integer
#  delivery_expected :boolean          default(FALSE)
#  event             :boolean          default(FALSE)
#

FactoryBot.define do
  factory :mission do
    name { Faker::Company.bs }
    description { Faker::Lorem.paragraph }
    max_member_count { rand(4..8) }
    min_member_count { rand(1..3) }
    start_date do
      Faker::Time.between_dates(from: Date.current - 3.months,
                                to: Date.current.at_end_of_week,
                                period: :day)
    end
    due_date { start_date + 7200 }
    association :author, factory: :member

    trait :event do
      event { true }
    end
  end
end
