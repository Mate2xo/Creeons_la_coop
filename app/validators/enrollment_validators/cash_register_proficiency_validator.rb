# frozen_string_literal: true

module EnrollmentValidators
  # This validator check the CashRegisterProficiencyValidator of the member when there is only one slot on a time slot
  class CashRegisterProficiencyValidator < ActiveModel::Validator
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
