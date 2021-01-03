# frozen_string_literal: true

module Missions
  # update missions enrollments according to enrollments type (with or without time slots)
  class UpdateTransaction
    include Dry::Transaction

    step :transform_time_slots_in_time_params_for_enrollment
    step :update

    def transform_time_slots_in_time_params_for_enrollment(params, regulated:)
      return Success(params) unless regulated

      params['enrollments_attributes'].each do |_key, enrollment|
        next if enrollment['time_slots'].nil?

        enrollment['end_time'] = enrollment['time_slots'].max.to_datetime + 90.minutes
        enrollment['start_time'] = enrollment['time_slots'].min
      end

      Success(final_params(params))
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

    def final_params(params)
      params.permit(
        :name, :description, :event, :delivery_expected,
        :recurrent, :recurrence_rule, :recurrence_end_date,
        :max_member_count, :min_member_count,
        :due_date, :start_date, :genre,
        enrollments_attributes: %i[id _destroy member_id start_time end_time]
      )
    end
  end
end
