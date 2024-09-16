# == Schema Information
#
# Table name: history_of_generated_schedules
#
#  id           :bigint           not null, primary key
#  month_number :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :history_of_generated_schedule do
    month_number { "2020-12-13 22:31:01" }
  end
end
