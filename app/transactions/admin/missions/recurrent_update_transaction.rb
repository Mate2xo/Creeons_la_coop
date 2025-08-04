# frozen_string_literal: true

module Admin
  module Missions
    # update mission and update recurrently if the recurrent change params is given
    class RecurrentUpdateTransaction
      include Dry::Transaction

      around :rollback_if_failure

      step :get_missions_to_update
      step :update_all_missions

      private

      ##
      # Executes the transaction steps within a database transaction and rolls back if any step fails.
      # @param input The initial input to the transaction.
      # @return The result of the transaction steps, with all changes rolled back if a failure occurs.
      def rollback_if_failure(input)
        result = nil

        Mission.transaction do
          result = yield(Success(input))
          raise ActiveRecord::Rollback if result.failure?

          result
        end
        result
      end

      ##
      # Determines the set of missions to update based on the original mission and parameters, adds them to the input, and returns a success result.
      # @param [Hash] input The input containing at least :old_mission and :params.
      # @return [Dry::Monads::Result] Success with the updated input including :all_missions.
      def get_missions_to_update(input)
        old_mission, params = input.values_at(:old_mission, :params)

        input.merge!({all_missions: missions_to_change(old_mission, params)})
        Success(input)
      end

      def update_all_missions(input)
        all_missions = input[:all_missions]
        params = input[:params][:recurrent_change] ? input[:params].except(:start_date, :due_date) : input[:params]

        all_missions.each do |current_mission|
          next if current_mission.update(params)

          return Failure(current_mission.errors.full_messages.join(', '))
        end
        Success(input)
      end

      ##
      # Determines the set of missions to update based on recurrence parameters.
      # If `:recurrent_change` is not set in the parameters, returns only the original mission.
      # If `:recurrent_change` is set, returns all missions with the same genre and a start date on or after the original mission's start date, further filtered to those matching the original mission's start time and weekday.
      # @param old_mission [Mission] The original mission to update.
      # @param params [Hash] Parameters that may include the `:recurrent_change` flag.
      # @return [Array<Mission>] The missions to be updated.

      def missions_to_change(old_mission, params)
        return [old_mission] unless params[:recurrent_change]

        all_missions = Mission.where('start_date >= :mission_start_date AND genre = :mission_genre',
                                     mission_start_date: old_mission.start_date,
                                     mission_genre: Mission.genres[old_mission.genre])
        all_missions.select do |current_mission|
          current_mission.start_date.strftime('%R%u') == old_mission.start_date.strftime('%R%u')
        end
      end
    end
  end
end
