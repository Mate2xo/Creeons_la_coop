# frozen_string_literal: true

module Admin
  module Enrollments
    # Create enrolment after a dateTimes validation
    class CreateTransaction # rubocop:disable Metrics/ClassLength
      include Dry::Transaction

      step :validation
      step :create_enrollment

      private

      def validation(enrollment) # rubocop:disable Metrics/AbcSize
        enrollment.check_if_enrollment_is_matching_the_mission_s_timeslots
        return Failure(enrollment.errors.values.flatten[0]) if enrollment.errors.present?

        Success(enrollment)
      end

      def check_if_enrollment_is_matching_the_mission_s_timeslots(input)
        return Success(input) unless input.mission.genre == 'regulated'

        failure_message = I18n.t('activerecord.errors.models.enrollment.time_slot_mismatch')
        return Failure(failure_message) unless match_a_time_slot?(input)

        Success(input)
      end

      def create_enrollment(input)
        new_enrollment = Enrollment.new(input.attributes)
        if new_enrollment.save
          Success(input)
        else
          return Failure(new_enrollment.errors.full_messages) unless Enrollment.create(input.attributes).valid?
        end
      end
    end
  end
end
