# frozen_string_literal: true

# == Schema Information
#
# Table name: static_slots
#
#  id         :bigint           not null, primary key
#  week_day   :integer          not null
#  start_time :datetime         not null
#  week_type  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :static_slot do
    week_day { 'Monday' }
    start_time { DateTime.new(2020, 1, 1, 9, 0) }
    week_type { 'A' }
  end
end
