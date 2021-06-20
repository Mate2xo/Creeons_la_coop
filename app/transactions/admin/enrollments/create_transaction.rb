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
        return Failure(enrollment.errors.values.flatten[0]) if enrollment.errors.present?

        Success(enrollment)
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
