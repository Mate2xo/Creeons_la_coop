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
    transient do
      on_event { false }
      mission_start_date { DateTime.current.beginning_of_day + 8.hours }
    end

    mission do
      if on_event
        association :mission, genre: 'event', start_date: mission_start_date
      else
        association :mission, start_date: mission_start_date
      end
    end
    association :member

    trait :one_hour do
      start_time { Time.zone.parse(mission.start_date.to_s) + 3600 }
    end
  end
end
