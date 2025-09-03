# frozen_string_literal: true

module Enrollments
  # Checks if enrollment datetimes are within the mission's dates.
  class MissionDatesInclusionValidator < ActiveModel::Validator
    ##
    # Validates that an enrollment's start and end datetimes fall within its mission's start and due dates.
    # Adds :inconsistent_datetimes to the enrollment's base errors if the datetimes are outside the mission period.
    # @param [Enrollment] enrollment - the enrollment instance to validate; must respond to `mission` and `errors`.
    def validate(enrollment)
      return if inside_period?(enrollment)

      enrollment.errors.add :base, :inconsistent_datetimes
    end

    ##
    # Returns true if the enrollment's start_time and end_time both fall within the mission's start_date and due_date (inclusive).
    #
    # Expects `enrollment` to respond to `mission.attributes` (containing 'start_date' and 'due_date') and `attributes` (containing 'start_time' and 'end_time').
    # Comparisons are inclusive: times equal to the mission boundaries are considered inside the period.
    # @param [Object] enrollment - object providing the required `mission` and `attributes` keys
    # @return [Boolean] whether both start_time and end_time lie between start_date and due_date (inclusive)
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
