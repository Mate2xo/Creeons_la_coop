# frozen_string_literal: true

module EnrollmentValidators
  # This validator check if the mission have a slot available for the new enrollment
  class AvailabilitySlotValidator < ActiveModel::Validator
    def validate(enrollment)
      return if enrollment.mission.max_member_count.nil?
      return unless enrollment.mission.genre == 'regulated'
      return if all_timeslots_covered_by_enrollment_available?(enrollment)

      failure_message = I18n.t('activerecord.errors.models.enrollment.slot_unavailability')
      enrollment.errors.add :base, failure_message
    end

    def all_timeslots_covered_by_enrollment_available?(enrollment)
      current_time_slot = enrollment.start_time
      while current_time_slot < enrollment.end_time
        return false if enrollment.mission.available_slots_count_for_a_time_slot(current_time_slot).zero?

        current_time_slot += 90.minutes
      end
      true
    end
  end
end
