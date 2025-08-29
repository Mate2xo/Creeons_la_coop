# frozen_string_literal: true

module Enrollments
  # If there is only one slot left on a regulated time slot,
  # checks that there is at least one Member trained on the cash register.
  class CashRegisterProficiencyValidator < ActiveModel::Validator
    def validate(enrollment)
      return unless enrollment.member

      mission = enrollment.mission
      untrained_level = Member.cash_register_proficiencies[:untrained]
      member_level = Member.cash_register_proficiencies[enrollment.member.cash_register_proficiency]
      return true unless enrollment.new_record? || enrollment.changed?

      if member_level > untrained_level ||
         mission.available_slots_count_for_a_time_slot(enrollment.start_time) > 1 ||
         mission.members.where(cash_register_proficiency: 1..).any?
        return true
      end

      enrollment.errors.add :member, :insufficient_cash_register_proficiency
    end
  end
end
