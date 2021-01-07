# frozen_string_literal: true

module Admin
  module Missions
    # update mission and update recurrently if the recurrent change params is given
    class UpdateTransaction
      include Dry::Transaction

      around :transaction

      step :update_mission
      tee :get_updatable_missions
      step :update_recurrently_other_missions

      private

      def transaction(input, &block)
        result = nil

        Mission.transaction do
          result = block.call(Success(input))
          raise ActiveRecord::Rollback if result.failure?

          result
        end
        result
      end

      def update_mission(input, mission:)
        if mission.update(input[:params])
          Success(input)
        else
          failure_message = I18n.t('activerecord.errors.messages.update_fail')
          Failure(failure_message)
        end
      end

      def get_updatable_missions(input, old_mission:)
        return Success(input) unless input[:params][:recurrent_change]

        input.merge!({ missions: updatable_missions(old_mission) })
        Success(input)
      end

      def update_recurrently_other_missions(input)
        return Success(input) unless input[:params][:recurrent_change]

        failure_message = I18n.t('activerecord.errors.messages.update_fail')

        input[:missions].each do |mission|
          return Failure(failure_message) unless mission.update(input[:params])
        end
        Success(input)
      end

      # helpers

      def updatable_missions(old_mission)
        Mission.all.select do |mission|
          mission.start_date > old_mission.start_date &&
            mission.start_date.strftime('%R%u') == old_mission.start_date.strftime('%R%u') &&
            mission.genre == old_mission.genre
        end
      end
    end
  end
end
