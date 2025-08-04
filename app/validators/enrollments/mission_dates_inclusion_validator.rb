# frozen_string_literal: true

module Enrollments
  # Checks if enrollment datetimes are within the mission's dates.
  class MissionDatesInclusionValidator < ActiveModel::Validator
    ##
    # Validates that the enrollment's start and end times are within the mission's date range.
    # Adds an error to the enrollment if the times are outside the mission period.
    # @param enrollment The enrollment object to validate.
    # @return [Boolean] true if the enrollment's datetimes are within the mission's dates, false otherwise.
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
