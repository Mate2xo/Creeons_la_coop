# frozen_string_literal: true

module Admin
  module Missions
    # update mission and update recurrently if the recurrent change params is given
    class UpdateTransaction
      include Dry::Transaction

      step :check_if_enrollment_are_inside_of_new_mission_s_period?
      step :check_if_enrollments_mission_s_time_slots_for_regulated_mission
      step :update_mission

      private

      def check_if_enrollment_are_inside_of_new_mission_s_period?(input)
        enrollments = input[:mission].enrollments
        failure_message = I18n.t('activerecord.errors.models.mission.inconsistent_datetimes_for_related_enrollments')
        enrollments.each do |enrollment|
          return Failure(failure_message) unless enrollment_inside_mission_s_period?(enrollment, input)
        end
        Success(input)
      end

      def check_if_enrollments_mission_s_time_slots_for_regulated_mission(input)
        enrollments = input[:mission].enrollments
        i18n_key =  'activerecord.errors.models.mission.mismatch_between_time_slots_and_related_enrollments'
        failure_message = I18n.t(i18n_key)
        enrollments.each do |enrollment|
          return Failure(failure_message) unless match_a_time_slot?(input, enrollment)
        end
        Success(input)
      end

      def update_mission(input)
        mission = input[:mission]
        if mission.update(input[:params])
          Success(input)
        else
          failure_message = mission.errors.full_messages.join
          Failure(failure_message)
        end
      end

      # helpers

      def enrollment_inside_mission_s_period?(enrollment, input)
        start_date = input[:params][:start_date]
        due_date = input[:params][:due_date]
        !(enrollment.start_time < start_date ||
          enrollment.start_time > due_date ||
          enrollment.end_time < start_date ||
          enrollment.end_time > due_date)
      end

      def match_a_time_slot?(input, enrollment)
        current_time_slot = input[:params][:start_date].to_datetime
        due_date = input[:params][:due_date]

        while current_time_slot < due_date # rubocop:disable Style/WhileUntilModifier
          return true if current_time_slot == enrollment.start_time

          current_time_slot += 90.minutes
        end
        false
      end
    end
  end
end
