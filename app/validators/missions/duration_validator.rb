# frozen_string_literal: true

module Missions
  # Checks:
  # * maximum duration of 16 hours
  # * positive duration
  # * for :regulated missions, duration is a multiple of Enrollment::TIME_SLOT_DURATION
  class DurationValidator < ActiveModel::Validator
    def validate(mission)
      return if mission.start_date.nil? || mission.due_date.nil?

      positive mission
      less_than_16_hours mission unless mission.event?
      multiple_of_time_slot mission if mission.regulated?
    end

    private

    def less_than_16_hours(mission)
      return true if mission.duration / 60 / 60 <= 16

      mission.errors.add :duration, :maximum
    end

    def positive(mission)
      return if mission.due_date > mission.start_date

      mission.errors.add :duration, :minimum
    end

    def multiple_of_time_slot(mission)
      return if (mission.duration % Enrollment::TIME_SLOT_DURATION).zero?

      mission.errors.add :duration, :multiple
    end
  end
end
