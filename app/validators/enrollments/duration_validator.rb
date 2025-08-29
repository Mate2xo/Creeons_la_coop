# frozen_string_literal: true

module Enrollments
  # Checks that the duration of the enrollment is positive.
  # For a regulated Mission, checks that it has a 90 min duration.
  class DurationValidator < ActiveModel::Validator
    def validate(enrollment)
      check_if_the_duration_is_positive(enrollment)
      check_if_duration_is_multiple_of_90_minutes(enrollment) if enrollment.mission.regulated?
    end

    def check_if_duration_is_multiple_of_90_minutes(enrollment)
      start_time, end_time = enrollment.attributes.values_at('start_time', 'end_time')
      return if ((end_time.to_i - start_time.to_i) % (60 * 90)).zero?

      enrollment.errors.add :base, :duration_is_not_a_multiple_of_90_minutes
    end

    def check_if_the_duration_is_positive(enrollment)
      return if enrollment.start_time < enrollment.end_time

      enrollment.errors.add :base, :negative_duration
    end
  end
end
