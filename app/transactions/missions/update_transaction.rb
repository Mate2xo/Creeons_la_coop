# frozen_string_literal: true

module Missions
  # update missions enrollments according to enrollments type (with or without time slots)
  class UpdateTransaction
    include Dry::Transaction

    step :transform_time_slots_in_time_params_for_enrollment
    step :update

    private

    def transform_time_slots_in_time_params_for_enrollment(params, regulated:)
      return Success(params) unless regulated
      return Success(params) if params['enrollments_attributes'].blank?

      params = transform_enroll_params(params)
      Success(params)
    end

    def update(params, mission:)
      if mission.update(params)
        Success(params)
      else
        failure_message = <<-MESSAGE
          "#{I18n.t('activerecord.errors.messages.update_fail')}
          #{mission.errors.full_messages.join(', ')}"
        MESSAGE
        Failure(failure_message)
      end
    end

    # helpers

    # this helper corrects the unpermitted params made by transform_enroll_params
    def auth_params(params)
      params.permit(
        :name, :description, :event, :delivery_expected,
        :recurrent, :recurrence_rule, :recurrence_end_date,
        :max_member_count, :min_member_count,
        :due_date, :start_date, :genre,
        enrollments_attributes: %i[id _destroy member_id start_time end_time]
      )
    end

    def transform_enroll_params(params)
      params['enrollments_attributes'].each do |_key, enrollment| # this loop unpermit the params
        next if enrollment['time_slots'].nil?

        enrollment['end_time'] = enrollment['time_slots'].max.to_datetime + 90.minutes
        enrollment['start_time'] = enrollment['time_slots'].min
      end
      auth_params(params)                                         # this helpers correct the unpermitted params
    end
  end
end
