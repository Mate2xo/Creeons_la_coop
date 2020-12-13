# frozen_string_literal: true

class GenerateScheduleJob < ApplicationJob # rubocop:disable  Style/Documentation
  queue_as :default

  def perform(*args)
    schedule_generator = ScheduleGenerator.new(args[0])
    schedule_generator.generate_schedule
    return unless schedule_generator.errors.empty?

    HistoryOfGeneratedSchedule.create(month_of_generated_schedule: (DateTime.current + 1.month).at_beginning_of_month)
  end
end
