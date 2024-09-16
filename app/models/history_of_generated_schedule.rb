# frozen_string_literal: true

# == Schema Information
#
# Table name: history_of_generated_schedules
#
#  id           :bigint           not null, primary key
#  month_number :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# This model retains the months for which a schedule had been generated
# This allows us to allow or prevent the launch of a GenerateScheduleJob : if no schedule has been created for a
# given month, we allow the GenerateScheduleJob to launch.
class HistoryOfGeneratedSchedule < ApplicationRecord
  validates :month_number, presence: true
end
