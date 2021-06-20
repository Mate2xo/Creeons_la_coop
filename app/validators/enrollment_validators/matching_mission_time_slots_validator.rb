# frozen_string_literal: true

module EnrollmentValidators
  # this validator check if the enrollment the timeslots of a regulated mission
  class MatchingMissionTimeSlotsValidator < ActiveModel::Validator
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
