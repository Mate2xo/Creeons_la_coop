# frozen_string_literal: true

module Admin
  module Missions
    # Updates mission and update recurrently if the recurrent change params is given
    class RecurrentUpdateTransaction
      include Dry::Transaction

      around :rollback_if_failure

      map :get_missions_to_update
      step :update_all_missions

      private

      def rollback_if_failure(input)
        result = nil

        Mission.transaction do
          result = yield(Success(input))
          raise ActiveRecord::Rollback if result.failure?

          result
        end
        result
      end

      # If `:recurrent_change` is not set in the parameters, returns only the original mission.
      # Otherwise returns all missions with the same genre
      # and a start date on or after the original mission's start date,
      # further filtered to those matching the original mission's start time and weekday.
      # @param old_mission [Mission] The original mission to update.
      # @param params [Hash] Controller parameters.
      # @return [Hash]
      def get_missions_to_update(params:, old_mission:)
        recurrent_change = params[:recurrent_change] == '1'
        missions = if recurrent_change
                     Mission.where('start_date >= :mission_start_date AND genre = :mission_genre',
                                   mission_start_date: old_mission.start_date,
                                   mission_genre: Mission.genres[old_mission.genre])
                            .select do |current_mission|
                       current_mission.start_date.strftime('%R%u') == old_mission.start_date.strftime('%R%u')
                     end
                   else
                     [old_mission]
                   end

        {params:, missions:, recurrent_change:}
      end

      def update_all_missions(params:, missions:, recurrent_change:)
        if recurrent_change
          params = params.except('start_date(1i)',
                                 'start_date(2i)',
                                 'start_date(3i)',
                                 'start_date(4i)',
                                 'start_date(5i)',
                                 'due_date(1i)',
                                 'due_date(2i)',
                                 'due_date(3i)',
                                 'due_date(4i)',
                                 'due_date(5i)')
        end

        missions.each do |current_mission|
          next if current_mission.update(params)

          return Failure(current_mission.errors.full_messages.join(', '))
        end
        Success(params:, missions:, recurrent_change:)
      end

      def missions_to_change(old_mission, params)
        return [old_mission] unless params[:recurrent_change] == '1'

        missions = Mission.where('start_date >= :mission_start_date AND genre = :mission_genre',
                                 mission_start_date: old_mission.start_date,
                                 mission_genre: Mission.genres[old_mission.genre])
        missions.select do |current_mission|
          current_mission.start_date.strftime('%R%u') == old_mission.start_date.strftime('%R%u')
        end
      end
    end
  end
end
