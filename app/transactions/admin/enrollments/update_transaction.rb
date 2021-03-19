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
      step :check_if_enrollment_are_matching_the_mission_s_timeslots
      step :check_slot_availability_for_regulated_mission
      step :check_cash_register_mastery

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

      def check_if_enrollment_are_matching_the_mission_s_timeslots(input)
        return Success(input) unless input[:mission].regulated?

        failure_message = I18n.t('activerecord.errors.models.enrollment.time_slot_mismatch')
        return Failure(failure_message) unless match_a_time_slot?(input)

        Success(input)
      end

      def check_slot_availability_for_regulated_mission(input)
        mission = input[:mission]
        failure_message = I18n.t('activerecord.errors.models.enrollment.slot_unavailability')
        return Success(input) if mission.genre != 'regulated'

        return Failure(failure_message) unless are_all_time_slots_available?(input)

        Success(input)
      end

      def check_cash_register_mastery(input)
        return Success(input) unless input[:mission].regulated?

        failure_message = I18n.t('activerecord.errors.models.enrollment.insufficient_cash_register_mastery')
        return Failure(failure_message) unless inspect_all_time_slots_for_register_cash_mastery(input)

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

      def are_all_time_slots_available?(input) # rubocop:disable Metrics/MethodLength
        mission = input[:mission]
        member = input[:member]

        current_time_slot = input[:start_time]
        while current_time_slot < input[:end_time]
          if mission.available_slots_count_for_a_time_slot(current_time_slot).zero? &&
             !mission.time_slot_already_taken_by_member?(current_time_slot, member)
            return false
          end

          current_time_slot += 90.minutes
        end
        true
      end

      def inspect_all_time_slots_for_register_cash_mastery(input) # rubocop:disable Metrics/MethodLength
        mission = input[:mission]
        member = input[:member]
        current_time_slot = input[:start_time]

        while current_time_slot < input[:end_time]
          if mission.available_slots_count_for_a_time_slot(current_time_slot) == 1 &&
             !are_cash_register_mastery_sufficient?(input) &&
             !mission.time_slot_already_taken_by_member?(current_time_slot, member)
            return false
          end

          current_time_slot += 90.minutes
        end

        true
      end

      def are_cash_register_mastery_sufficient?(input)
        mission = input[:mission]
        member = input[:member]

        mastery_level_of_member = Member.cash_register_proficiencies[member.cash_register_proficiency]

        proficiency_requirement = mission.cash_register_proficiency_requirement
        mastery_level_of_mission = Mission.cash_register_proficiency_requirements[proficiency_requirement]

        mastery_level_of_member >= mastery_level_of_mission
      end
    end
  end
end
