# frozen_string_literal: true

module Admin
  module Missions
    # update mission and update recurrently if the recurrent change params is given
    class RecurrentUpdateTransaction
      include Dry::Transaction

      around :rollback_if_failure

      tee :get_missions_to_update
      step :update_all_missions

      private

      def rollback_if_failure(input, &block)
        result = nil

        Mission.transaction do
          result = block.call(Success(input))
          raise ActiveRecord::Rollback if result.failure?

          result
        end
        result
      end

      def get_missions_to_update(input)
        old_mission, params = input.values_at(:old_mission, :params)

        input.merge!({ all_missions: missions_to_change(old_mission, params) })
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

      # helpers

      def missions_to_change(old_mission, params)
        return [old_mission] unless params[:recurrent_change]

        all_missions = Mission.where('start_date >= :mission_start_date AND genre = :mission_genre',
                                     mission_start_date: old_mission.start_date,
                                     mission_genre: Mission.genres[old_mission.genre])
        all_missions.select do |current_mission|
          current_mission.start_date.strftime('%R%u') == old_mission.start_date.strftime('%R%u')
        end
      end

      def determine_failure_message(failure, mission)
        I18n.t('activerecord.errors.models.mission.recurrent_update_cancel',
               name: mission.name,
               start_date: mission.start_date,
               failure: failure)
      end
    end
  end
end
