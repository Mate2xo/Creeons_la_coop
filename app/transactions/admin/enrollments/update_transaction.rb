# frozen_string_literal: true

module Admin
  module Enrollments
    # update enrolment after a dateTimes validation
    class UpdateTransaction # rubocop:disable Metrics/ClassLength
      include Dry::Transaction

      tee :convert_params_in_datetime
      tee :prepare_object
      step :validation
      step :update_enrollment

      private

      def convert_params_in_datetime(input)
        start_time = convert_datetime(input[:params], 'start_time')
        end_time = convert_datetime(input[:params], 'end_time')
        input[:params].merge!(start_time: start_time, end_time: end_time)
        Success(input)
      end

      def prepare_object(input)
        enrollment = input[:enrollment]
        params = input[:params]

        params.keys.each do |current_key| # rubocop:disable Style/HashEachMethods
          enrollment[current_key] = params[current_key] if enrollment.attributes.keys.include?(current_key)
        end
      end

      def validation(input) # rubocop:disable Metrics/AbcSize
        enrollment = input[:enrollment]
        enrollment.check_if_enrollment_is_matching_the_mission_s_timeslots
        return Failure(enrollment.errors.values.flatten[0]) if enrollment.errors.present?

        Success(input)
      end

      def update_enrollment(input)
        enrollment = input[:enrollment]
        params = input[:params]
        if enrollment.save
          Success(enrollment)
        else
          Failure(enrollment.errors.full_messages)
        end
      end

      # helpers

      def convert_datetime(params, key)
        DateTime.new(
          params["#{key}(1i)"].to_i,
          params["#{key}(2i)"].to_i,
          params["#{key}(3i)"].to_i,
          params["#{key}(4i)"].to_i,
          params["#{key}(5i)"].to_i
        )
      end
    end
  end
end
