# frozen_string_literal: true

class GenerateScheduleJob < ApplicationJob # rubocop:disable  Style/Documentation
  queue_as :default

  def perform(options)
    schedule_generator = ScheduleGenerator.new(options[:current_member], options[:current_month].to_datetime)
    schedule_generator.generate_schedule
    return unless schedule_generator.errors.empty?

    HistoryOfGeneratedSchedule.create(month_number: options[:current_month].to_datetime)
  end
end
