# frozen_string_literal: true

FactoryBot.define do
  factory :static_slot do
    week_day { 'Monday' }
    hour { 9 }
    minute { 0 }
    week_type { 'A' }
  end
end
