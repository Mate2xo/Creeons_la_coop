# frozen_string_literal: true

module EnrollmentValidators
  # This validator check if the duration of the enrollment is positve
  class DurationValidator < ActiveModel::Validator
    def validate(enrollment)
      check_if_the_duration_is_positive(enrollment)
      check_if_duration_is_multiple_of_90_minutes(enrollment) if enrollment.mission.genre == 'regulated'
    end

    def check_if_duration_is_multiple_of_90_minutes(enrollment)
      start_time, end_time = enrollment.attributes.values_at('start_time', 'end_time')
      return if ((end_time.to_i - start_time.to_i) % (60 * 90)).zero?

      failure_message = I18n.t('activerecord.errors.models.enrollment.duration_is_not_a_multiple_of_90_minutes')
      enrollment.errors.add :base, failure_message
    end

    def check_if_the_duration_is_positive(enrollment)
      return if enrollment.start_time < enrollment.end_time

      failure_message = I18n.t('activerecord.errors.models.enrollment.negative_duration')
      enrollment.errors.add :base, failure_message
    end
  end
end
