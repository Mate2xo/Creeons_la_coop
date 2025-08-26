# frozen_string_literal: true

module Enrollments
  # If there is only one slot left on a regulated time slot,
  # checks if the enrolled Member's proficiency on the cash register
  # matches the minimum level required for the associated Mission
  class CashRegisterProficiencyValidator < ActiveModel::Validator
    # Returns false if only one slot remains for the given time slot
    # and the member's proficiency is below the mission's required level.
    #
    # @param [Mission] mission The mission for which the slot availability is checked.
    # @param [DateTime] time_slot Time at which availability is checked.
    # @param proficiency_level The member's cash register proficiency level.
    # @return [Boolean]
    def slot_available_for_a_given_cash_register_proficiency_level?(mission, time_slot, proficiency_level)
      required_proficiency_level =
        Mission.cash_register_proficiency_requirements[mission.cash_register_proficiency_requirement]

      return false if mission.available_slots_count_for_a_time_slot(time_slot) == 1 &&
                      (proficiency_level < required_proficiency_level)

      true
    end

    alias slot_available? slot_available_for_a_given_cash_register_proficiency_level?

    def validate(enrollment)
      mission = enrollment.mission
      member = enrollment.member

      return true unless mission.regulated?

      proficiency_level_of_member = Member.cash_register_proficiencies[member.cash_register_proficiency]
      unless slot_available?(enrollment.mission, enrollment.start_time, proficiency_level_of_member)
        failure_message = I18n.t('activerecord.errors.models.enrollment.insufficient_cash_register_proficiency')
        enrollment.errors.add :base, failure_message
        return false
      end
      true
    end
  end
end
