# frozen_string_literal: true

module Missions
  # update missions enrollments according to enrollments type (with or without time slots)
  class UpdateTransaction
    include Dry::Transaction

    step :transform_time_slots_in_time_params_for_enrollment
    step :update

    private

    ##
    # Transform enrollment nested `:time_slots` into explicit `:start_time` and `:end_time` values when `regulated` is truthy.
    #
    # For each enrollment in `params[:enrollments_attributes]`:
    # - If `:time_slots` is present and non-blank, it is removed from the enrollment.
    # - `:start_time` is set to the minimum time slot converted with `to_datetime`.
    # - `:end_time` is set to the maximum time slot converted with `to_datetime` plus `Enrollment::TIME_SLOT_DURATION`.
    #
    # The method mutates the provided `params` hash in place and always returns Success(params).
    # @param [Hash] params - A params-like hash containing `:enrollments_attributes` (a hash of enrollment attribute hashes). Each enrollment may include `:time_slots` (an array of time-like values).
    # @param [Boolean] regulated - If falsey, no transformation is performed and `params` is returned unchanged.
    # @return [Dry::Monads::Result] Success containing the (possibly mutated) `params`.
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

    ##
    # Persists the given attributes to the mission, returning a Dry::Monads result.
    # @param [Hash] params - Attributes to update on the mission.
    # @param [Mission] mission - The mission record to update.
    # @return [Dry::Monads::Result] Success(params) if the update succeeds; Failure(String) with `mission.errors.full_messages.to_sentence` otherwise.
    def update(params, mission:)
      if mission.update(params)
        Success(params)
      else
        Failure(mission.errors.full_messages.to_sentence)
      end
    end
  end
end
