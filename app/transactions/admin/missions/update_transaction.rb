# frozen_string_literal: true

module Admin
  module Missions
    # update mission and update recurrently if the recurrent change params is given
    class UpdateTransaction
      include Dry::Transaction

      step :update_mission

      private

      def update_mission(input)
        mission = input[:mission]
        if mission.update(input[:params])
          Success(input)
        else
          failure_message = I18n.t('activerecord.errors.messages.update_fail')
          Failure(failure_message)
        end
      end
    end
  end
end
