# frozen_string_literal: true

module Admin
  module Enrollments
    # Create enrolment after a dateTimes validation
    class CreateTransaction
      include Dry::Transaction

      around :rollback_if_failure

      tee :convert_params_in_datetime
      step :check_member_if_member_is_already_enrolled
      step :check_if_the_duration_is_positive
      step :check_if_datetimes_of_enrollment_are_inside_the_mission_s_period
      step :check_if_enrollment_are_matching_the_mission_s_timeslots
      step :create_enrollment

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

      def check_member_if_member_is_already_enrolled(input)
        mission = input[:mission]
        member = input[:member]
        failure_message = I18n.t('activerecord.errors.models.enrollment.member_already_enrolled')

        return Failure(failure_message) if mission.members.include?(member)

        Success(input)
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

      def check_if_enrollment_are_matching_the_mission_s_timeslots(input)
        return Success(input) unless input[:mission].genre == 'regulated'

        failure_message = I18n.t('activerecord.errors.models.enrollment.time_slot_mismatch')
        return Failure(failure_message) unless match_a_time_slot?(input)

        Success(input)
      end

      def create_enrollment(input)
        failure_message = I18n.t('activerecord.errors.messages.update_fail')
        mission = input[:mission]
        input.merge!(mission_id: mission.id)
        return Failure(failure_message) unless Enrollment.create(input).valid?

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

      def match_a_time_slot?(input)
        mission = input[:mission]
        return false unless ((input[:start_time].to_i - input[:end_time].to_i) % (60 * 90)).zero?

        current_time_slot = mission.start_date
        while current_time_slot < mission.due_date
          return true if current_time_slot == input[:start_time]

          current_time_slot += 90.minutes
        end
        false
      end
    end
  end
end
