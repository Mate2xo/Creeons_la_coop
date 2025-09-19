# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  id             :bigint           not null, primary key
#  end_time       :datetime
#  old_end_time   :time
#  old_start_time :time
#  start_time     :datetime
#  member_id      :bigint           not null
#  mission_id     :bigint           not null
#
# Indexes
#
#  index_enrollments_on_mission_id  (mission_id)
#

FactoryBot.define do
  factory :enrollment do
    mission
    member

    trait :one_hour do
      start_time { Time.zone.parse(mission.start_date.to_s) + 3600 }
    end

    trait :on_first_time_slot do
      mission factory: %i[mission regulated]
      start_time { mission.start_date.to_datetime }
      end_time { start_time + Enrollment::TIME_SLOT_DURATION }
    end

    trait :on_last_time_slot do
      mission factory: %i[mission regulated]
      end_time { mission.due_date.to_datetime }
      start_time { end_time - Enrollment::TIME_SLOT_DURATION }
    end
  end
end
