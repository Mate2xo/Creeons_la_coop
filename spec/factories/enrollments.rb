# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  id             :bigint           not null, primary key
#  member_id      :bigint           not null
#  mission_id     :bigint           not null
#  old_start_time :time
#  old_end_time   :time
#  start_time     :datetime
#  end_time       :datetime
#

FactoryBot.define do
  factory :enrollment do
    association :mission
    association :member

    trait :one_hour do
      start_time { Time.zone.parse(mission.start_date.to_s) + 3600 }
    end
  end
end
