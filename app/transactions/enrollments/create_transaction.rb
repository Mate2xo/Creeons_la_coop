# frozen_string_literal: true

module Enrollments
  # create enrollments after prepare params
  class CreateTransaction
    include Dry::Transaction

    step :validate
    step :transform_time_slots_in_time_params_for_enrollment
    step :create

    def validate(permitted_params, mission:)
      return Success(permitted_params) if mission.max_member_count.nil?
      return Success(permitted_params) if mission.members.count < mission.max_member_count

      failure_message = I18n.t('enrollments.create.max_member_count_reached')
      Failure(failure_message)
    end

    def transform_time_slots_in_time_params_for_enrollment(permitted_params, regulated:, time_slots:)
      return Success(permitted_params) unless regulated
      return Failure(I18n.t('enrollments.create.time_slots_requirement')) if time_slots.blank?

      time_slots = time_slots.sort
      permitted_params['start_time'] = time_slots.first
      permitted_params['end_time'] = time_slots.last.to_datetime + 90.minutes
      permitted_params.delete(:time_slots)

      Success(permitted_params)
    end

    def create(permitted_params)
      enrollment = Enrollment.new(permitted_params)
      if enrollment.save
        Success(permitted_params)
      else
        failure_message = "#{I18n.t('.enroll_error')} #{enrollment.errors.full_messages.join(', ')}"
        Failure(failure_message)
      end
    end
  end
end
