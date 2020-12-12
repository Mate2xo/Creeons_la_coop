# frozen_string_literal: true

FactoryBot.define do
  factory :static_slot do
    week_day { 'Monday' }
    start_time { DateTime.new(2020, 1, 1, 9, 0) }
    week_type { 'A' }
  end
end
