# frozen_string_literal: true

# It Generate slot after a mission creation
class Slot::Generator < ApplicationService
  def initialize(mission)
    @mission = mission
  end

  def call
    return if @mission.max_member_count.nil?

    @mission.max_member_count.times do
      start_time = @mission.start_date
      while start_time < @mission.due_date
        Mission::Slot.create!(start_time: start_time, mission_id: @mission.id)
        start_time += 90.minutes
      end
    end
  end
end
