# frozen_string_literal: true

# This model retains the months for which a schedule had been generated
class HistoryOfGeneratedSchedule < ApplicationRecord
  validates :month_number, presence: true
end
