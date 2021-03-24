# frozen_string_literal: true

module Admin
  module Enrollments
    # Create enrolment after a dateTimes validation
    class CreateTransaction # rubocop:disable Metrics/ClassLength
      include Dry::Transaction

      around :rollback_if_failure

      step :check_member_if_member_is_already_enrolled
      step :check_if_the_standard_mission_is_not_full
      step :check_if_the_duration_is_positive
      step :check_if_datetimes_of_enrollment_are_inside_the_mission_s_period
      step :check_if_enrollment_are_matching_the_mission_s_timeslots
      step :check_slot_availability_for_regulated_mission
      step :check_cash_register_mastery
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
        mission = input.mission
        member = input.member
        failure_message = I18n.t('activerecord.errors.models.enrollment.member_already_enrolled')

        return Failure(failure_message) if mission.members.include?(member)

        Success(input)
      end

      def check_if_the_standard_mission_is_not_full(input)
        mission = input.mission

        failure_message = I18n.t('activerecord.errors.models.enrollment.full_mission')
        return Success(input) if mission.genre != 'standard'
        return Failure(failure_message) unless mission.members.count < mission.max_member_count

        Success(input)
      end

      def check_if_the_duration_is_positive(input)
        failure_message = I18n.t('activerecord.errors.models.enrollment.negative_duration')
        return Failure(failure_message) unless input.start_time < input.end_time

        Success(input)
      end

      def check_if_datetimes_of_enrollment_are_inside_the_mission_s_period(input)
        failure_message = I18n.t('activerecord.errors.models.enrollment.inconsistent_datetimes')
        mission = input.mission
        return Failure(failure_message) unless input[:start_time] >= mission.start_date &&
                                               input[:start_time] <= mission.due_date &&
                                               input[:end_time] >= mission.start_date &&
                                               input[:end_time] <= mission.due_date

        Success(input)
      end

      def check_if_enrollment_are_matching_the_mission_s_timeslots(input)
        return Success(input) unless input.mission.genre == 'regulated'

        failure_message = I18n.t('activerecord.errors.models.enrollment.time_slot_mismatch')
        return Failure(failure_message) unless match_a_time_slot?(input)

        Success(input)
      end

      def check_slot_availability_for_regulated_mission(input)
        failure_message = I18n.t('activerecord.errors.models.enrollment.slot_unavailability')
        return Success(input) if input.mission.genre != 'regulated'

        return Failure(failure_message) unless are_all_timeslots_available?(input)

        Success(input)
      end

      def check_cash_register_mastery(input)
        return Success(input) unless input.mission.genre == 'regulated'

        failure_message = I18n.t('activerecord.errors.models.enrollment.insufficient_cash_register_mastery')
        return Failure(failure_message) unless inspect_all_slots_for_register_cash_mastery(input)

        Success(input)
      end

      def create_enrollment(input)
        failure_message = I18n.t('activerecord.errors.messages.update_fail')
        return Failure(failure_message) unless Enrollment.create(input.attributes).valid?

        Success(input)
      end

      # helpers

      def match_a_time_slot?(input)
        mission = input.mission
        return false unless ((input.end_time.to_i - input.start_time.to_i) % (60 * 90)).zero?

        current_time_slot = mission.start_date
        while current_time_slot < mission.due_date
          return true if current_time_slot == input.start_time

          current_time_slot += 90.minutes
        end
        false
      end

      def are_all_timeslots_available?(input)
        mission = input.mission

        current_time_slot = input.start_time
        while current_time_slot < input.end_time
          return false if mission.available_slots_count_for_a_time_slot(current_time_slot).zero?

          current_time_slot += 90.minutes
        end
        true
      end

      def inspect_all_slots_for_register_cash_mastery(input)
        current_time_slot = input.start_time

        while current_time_slot < input.end_time
          if input.mission.available_slots_count_for_a_time_slot(current_time_slot) == 1 &&
             !are_cash_register_mastery_sufficient?(input)
            return false
          end

          current_time_slot += 90.minutes
        end

        true
      end

      def are_cash_register_mastery_sufficient?(input)
        mission = input.mission
        member = input.member

        mastery_level_of_member = Member.cash_register_proficiencies[member.cash_register_proficiency]

        proficiency_requirement = mission.cash_register_proficiency_requirement
        mastery_level_of_mission = Mission.cash_register_proficiency_requirements[proficiency_requirement]

        mastery_level_of_member >= mastery_level_of_mission
      end
    end
  end
end
