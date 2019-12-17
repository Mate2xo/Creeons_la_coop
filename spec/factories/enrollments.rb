# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  member_id  :bigint(8)        not null
#  mission_id :bigint(8)        not null
#  id         :bigint(8)        not null, primary key
#  start_time :time
#  end_time   :time
#

FactoryBot.define do
  factory :enrollment do
    member
    mission
    start_time { mission.start_date.to_time }
    end_time { mission.due_date.to_time }

    trait :one_hour do
      start_time { mission.start_date.to_time + 3600 }
    end
  end
end
