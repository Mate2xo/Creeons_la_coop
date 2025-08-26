# frozen_string_literal: true

module Enrollments
  # Checks if the given :start_time matches with the associated regulated Mission's 90-minutes time slots.
  # E.g.:
  # - a given regulated Mission starts at 10 AM and ends at 1 PM
  # - time slots are 90 minutes long, so there are 2 in this mission:
  #   > one starting at 10 AM
  #   > the other starting at 11:30 AM
  # - an enrollment would be invalid if it starts at 10:15 AM.
  #   It should start at 10 AM or 11:30 AM
  class Mission90minTimeSlotsMatchValidator < ActiveModel::Validator
    def validate(enrollment)
      return unless enrollment.mission.genre == 'regulated'
      return if match_a_mission_time_slot?(enrollment)

      failure_message = I18n.t('activerecord.errors.models.enrollment.time_slot_mismatch')
      enrollment.errors.add :base, failure_message
    end

    def match_a_mission_time_slot?(enrollment)
      current_time_slot = enrollment.mission.start_date

      while current_time_slot < enrollment.mission.due_date
        return true if current_time_slot == enrollment.start_time

        current_time_slot += 90.minutes
      end
    end
  end
end
