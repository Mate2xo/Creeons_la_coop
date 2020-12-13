# frozen_string_literal: true

class GenerateScheduleJob < ApplicationJob # rubocop:disable  Style/Documentation
  queue_as :default

  def perform(*args)
    schedule_generator = ScheduleGenerator.new(args[0])
    schedule_generator.generate_schedule
  end
end
