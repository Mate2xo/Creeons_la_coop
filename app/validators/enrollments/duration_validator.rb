# frozen_string_literal: true

module Enrollments
  # Checks that the duration of the enrollment is positive.
  # For a regulated Mission, checks that it has a 90 min duration.
  class DurationValidator < ActiveModel::Validator
    ##
    # Validates an enrollment's duration.
    #
    # Performs two checks and adds errors to the enrollment record when invalid:
    # - Ensures the enrollment's start time is strictly before its end time.
    # - If the enrollment's mission is regulated, ensures the duration is a multiple of 90 minutes.
    # @param [Enrollment] enrollment The record being validated; errors are added to this object when checks fail.
    def validate(enrollment)
      check_if_the_duration_is_positive(enrollment)
      check_if_duration_is_multiple_of_90_minutes(enrollment) if enrollment.mission&.regulated?
    end

    ##
    # Ensures an enrollment's duration (end_time − start_time) is a multiple of 90 minutes.
    #
    # If either time is blank the check is skipped. On violation, adds
    # :duration_is_not_a_multiple_of_90_minutes to enrollment.errors[:base].
    # @param [#attributes, #errors] enrollment - an Enrollment-like object with `start_time` and `end_time` attributes.
    def check_if_duration_is_multiple_of_90_minutes(enrollment)
      start_time, end_time = enrollment.attributes.values_at('start_time', 'end_time')
      return if start_time.blank? || end_time.blank?
      return if ((end_time.to_i - start_time.to_i) % (60 * 90)).zero?

      enrollment.errors.add :base, :duration_is_not_a_multiple_of_90_minutes
    end

    ##
    # Validates that an enrollment's start time is strictly before its end time.
    #
    # Returns early if either `start_time` or `end_time` is blank. If `start_time` is
    # not less than `end_time`, adds a :negative_duration error on `enrollment.errors[:base]`.
    # @param [#attributes, #start_time, #end_time, #errors] enrollment - object with `start_time` and `end_time` attributes (e.g., an ActiveRecord model)
    def check_if_the_duration_is_positive(enrollment)
      start_time, end_time = enrollment.attributes.values_at('start_time', 'end_time')
      return if start_time.blank? || end_time.blank?
      return if enrollment.start_time < enrollment.end_time

      enrollment.errors.add :base, :negative_duration
    end
  end
end
