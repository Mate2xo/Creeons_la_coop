# frozen_string_literal: true

module Enrollments
  # Checks if the given 'regulated' mission has an available time slot available for a new enrollment
  class TimeSlotAvailabilityValidator < ActiveModel::Validator
    ##
    # Validates that all time slots required by the enrollment are available for a regulated mission.
    # Adds an error to the enrollment if any required time slot is fully booked.
    def validate(enrollment)
      mission = enrollment.mission
      return unless mission.regulated? && mission.max_member_count && mission.persisted?
      return if all_timeslots_covered_by_enrollment_are_available?(enrollment)

      enrollment.errors.add :mission, :no_slots_available
    end

    private

    ##
    # Checks if all 90-minute time slots within the enrollment period have available capacity.
    # Returns false if any slot is fully booked; otherwise, returns true.
    # @param enrollment The enrollment to check time slot availability for.
    # @return [Boolean] True if all time slots are available, false otherwise.
    def all_timeslots_covered_by_enrollment_are_available?(enrollment)
      current_time_slot = enrollment.start_time
      while current_time_slot < enrollment.end_time
        return false if available_slots_count_for(current_time_slot, enrollment).zero?

        current_time_slot += 90.minutes
      end
      true
    end

    ##
    # Calculates the number of available slots for a given time slot in a mission, excluding the current enrollment.
    # @param [Time] time_slot - The start time of the slot to check.
    # @param [Enrollment] enrollment - The enrollment being validated.
    # @return [Integer] The number of available slots for the specified time slot.
    def available_slots_count_for(time_slot, enrollment)
      mission = enrollment.mission
      occupied_slots_count =
        mission.enrollments.where.not(id: enrollment)
               .where('start_time <= :time_slot AND :time_slot < end_time', time_slot: time_slot)
               .count
      mission.max_member_count - occupied_slots_count
    end
  end
end
