# frozen_string_literal: true

module Admin
  module Enrollments
    # update enrolment after a dateTimes validation
    class UpdateTransaction # rubocop:disable Metrics/ClassLength
      include Dry::Transaction

      around :rollback_if_failure

      tee :convert_params_in_datetime
      step :check_if_the_duration_is_positive
      step :check_if_datetimes_of_enrollment_are_inside_the_mission_s_period

      private

      def rollback_if_failure(input, &block)
        result = nil

        Enrollment.transaction do
          result = block.call(Success(input))
          raise ActiveRecord::Rollback if result.failure?

          result
        end
        result
      end

      def convert_params_in_datetime(input)
        start_time = convert_datetime(input, 'start_time')
        end_time = convert_datetime(input, 'end_time')
        input.merge!(start_time: start_time, end_time: end_time)
        Success(input)
      end

      def check_if_the_duration_is_positive(input)
        failure_message = I18n.t('activerecord.errors.models.enrollment.negative_duration')
        return Failure(failure_message) unless input[:start_time] < input[:end_time]

        Success(input)
      end

      def check_if_datetimes_of_enrollment_are_inside_the_mission_s_period(input)
        failure_message = I18n.t('activerecord.errors.models.enrollment.inconsistent_datetimes')
        mission = input[:mission]
        return Failure(failure_message) unless input[:start_time] >= mission.start_date &&
                                               input[:start_time] <= mission.due_date &&
                                               input[:end_time] >= mission.start_date &&
                                               input[:end_time] <= mission.due_date

        Success(input)
      end

      # helpers

      def convert_datetime(input, key)
        DateTime.new(
          input["#{key}(1i)"].to_i,
          input["#{key}(2i)"].to_i,
          input["#{key}(3i)"].to_i,
          input["#{key}(4i)"].to_i,
          input["#{key}(5i)"].to_i
        )
      end
    end
  end
end
