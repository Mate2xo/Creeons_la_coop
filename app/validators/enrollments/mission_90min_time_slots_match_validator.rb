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
    ##
    # Validates that an enrollment's start time falls on one of the mission's 90-minute time slots.
    #
    # Only runs for missions where `mission.regulated?` is true. If the enrollment's start time
    # does not match any permitted time slot, adds an error on the `:mission` attribute with
    # the `:time_slot_mismatch` symbol.
    # @param [Enrollment] enrollment - the enrollment record being validated
    def validate(enrollment)
      return unless enrollment.mission.regulated?
      return if match_a_mission_time_slot?(enrollment)

      enrollment.errors.add :mission, :time_slot_mismatch
    end

    ##
    # Checks whether the enrollment's start_time falls exactly on one of the mission's time slots.
    #
    # Iterates from the mission's start_date (inclusive) up to, but not including, the mission's due_date,
    # advancing by Enrollment::TIME_SLOT_DURATION and comparing each slot to enrollment.start_time.
    # @param [Enrollment] enrollment - The enrollment whose start_time and associated mission are checked.
    # @return [TrueClass, nil] Returns true if a matching time slot is found; returns nil otherwise.
    def match_a_mission_time_slot?(enrollment)
      current_time_slot = enrollment.mission.start_date

      while current_time_slot < enrollment.mission.due_date
        return true if current_time_slot == enrollment.start_time

        current_time_slot += Enrollment::TIME_SLOT_DURATION
      end
    end
  end
end
