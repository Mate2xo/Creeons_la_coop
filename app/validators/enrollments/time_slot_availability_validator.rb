# frozen_string_literal: true

module Enrollments
  # Checks if the given 'regulated' mission has an available time slot available for a new enrollment
  class TimeSlotAvailabilityValidator < ActiveModel::Validator
    def validate(enrollment)
      mission = enrollment.mission
      return unless mission.regulated? && mission.max_member_count && mission.persisted?
      return if all_timeslots_covered_by_enrollment_are_available?(enrollment)

      enrollment.errors.add :mission, :no_slots_available
    end

    private

    def all_timeslots_covered_by_enrollment_are_available?(enrollment)
      current_time_slot = enrollment.start_time
      while current_time_slot < enrollment.end_time
        return false if available_slots_count_for(current_time_slot, enrollment).zero?

        current_time_slot += 90.minutes
      end
      true
    end

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
