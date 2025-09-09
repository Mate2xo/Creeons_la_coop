# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                               :bigint           not null, primary key
#  name                             :string           not null
#  description                      :text             not null
#  due_date                         :datetime
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  author_id                        :bigint
#  start_date                       :datetime
#  recurrent                        :boolean
#  max_member_count                 :integer
#  min_member_count                 :integer
#  delivery_expected                :boolean          default(FALSE)
#  genre                            :integer          default("standard")
#  cash_register_close_out_required :boolean          default(FALSE), not null
#

FactoryBot.define do
  factory :mission do
    name { Faker::Company.bs }
    description { Faker::Lorem.paragraph }
    max_member_count { 4 }
    min_member_count { 1 }
    start_date do
      Faker::Time.between_dates(from: Date.current.at_beginning_of_week,
                                to: Date.current.at_end_of_week,
                                period: :day)
                 .beginning_of_minute
                 .to_datetime
    end
    due_date { start_date + 3.hours }
    author factory: :member

    trait :regulated do
      genre { :regulated }
    end

    trait :recurrent do
      recurrent { true }
      recurrence_rule do
        {
          interval: 1,
          until: nil,
          count: nil,
          validations: {day: [2, 3, 5, 6]},
          rule_type: IceCube::WeeklyRule,
          week_start: 1
        }.to_json
      end
      recurrence_end_date { DateTime.now.beginning_of_week + 1.week }
    end

    transient do
      with_enrollments { 0 }
    end

    enrollments do
      Array.new(with_enrollments) do
        association :enrollment, mission: instance, member: build(:member, :beginner)
      end
    end
  end
end
