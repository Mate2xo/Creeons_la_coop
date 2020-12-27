# frozen_string_literal: true

module Missions
  # update missions enrollments according to enrollments type (with or without time slots)
  class UpdateTransaction
    include Dry::Transaction

    step :validate
    tee :prepare_params
    step :update

    def validate(input)
      return Success(input) if input[:genre] != 'regulated'

      failure_message = "#{I18n.t('activerecord.errors.messages.update_fail')}
      #{I18n.t('missions.update.time_slot_requirement')}"
      input['enrollments_attributes'].each do |_key, enrollment|
        return Failure(failure_message) if enrollment['start_time'].nil?
      end

      Success(input)
    end

    def prepare_params(input)
      return Success(input) if input[:genre] != 'regulated'

      input['enrollments_attributes'].each do |_key, enrollment|
        enrollment['end_time'] = enrollment['start_time'].last.to_datetime + 90.minutes
        enrollment['start_time'] = enrollment['start_time'].first
      end

      Success(input)
    end

    def update(input, mission:)
      if mission.update(input)
        Success(input)
      else
        failure_message = "#{I18n.t('activerecord.errors.messages.update_fail')}
        #{mission.errors.full_messages.join(', ')}"
        Failure(failure_message)
      end
    end
  end
end
