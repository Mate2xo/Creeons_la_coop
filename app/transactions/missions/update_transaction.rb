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
      return Success(params) if params[:enrollments_attributes].blank?

      params[:enrollments_attributes].each_value do |enrollment|
        next if (time_slots = enrollment.delete(:time_slots)).blank?

        enrollment[:end_time] = time_slots.max.to_datetime + Enrollment::TIME_SLOT_DURATION
        enrollment[:start_time] = time_slots.min.to_datetime
      end
      Success(params)
    end

    def update(params, mission:)
      if mission.update(params)
        Success(params)
      else
        Failure(mission.errors.full_messages.to_sentence)
      end
    end
  end
end
