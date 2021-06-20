# frozen_string_literal: true

module EnrollmentValidators
  # This validator check if the duration of the enrollment is positve
  class DurationValidator < ActiveModel::Validator
    def validate(enrollment)
      return if enrollment.start_time < enrollment.end_time

      failure_message = I18n.t('activerecord.errors.models.enrollment.negative_duration')
      enrollment.errors.add :base, failure_message
    end
  end
end
