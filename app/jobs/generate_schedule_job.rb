class GenerateScheduleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    schedule_generator = ScheduleGenerator.new(args[0])
  end
end
