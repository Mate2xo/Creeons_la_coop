# frozen_string_literal: true

module EnrollmentValidators
  # check_if_datetimes_of_enrollment_are_inside_the_mission_s_period
  class DatetimesInclusionValidator < ActiveModel::Validator
    def validate(enrollment)
      unless inside_period?(enrollment)
        failure_message = I18n.t('activerecord.errors.models.enrollment.inconsistent_datetimes')
        enrollment.errors.add :inconsistent_datetimes, failure_message
        return false
      end

      true
    end

    def inside_period?(enrollment)
      start_date, due_date = enrollment.mission.attributes.values_at('start_date', 'due_date')
      start_time, end_time = enrollment.attributes.values_at('start_time', 'end_time')

      start_time >= start_date &&
        start_time <= due_date &&
        end_time >= start_date &&
        end_time <= due_date
    end
  end
end
