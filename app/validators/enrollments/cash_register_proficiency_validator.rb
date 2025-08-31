# frozen_string_literal: true

module Enrollments
  # If there is only one slot left on a regulated time slot,
  # checks that there is at least one Member trained on the cash register.
  class CashRegisterProficiencyValidator < ActiveModel::Validator
    def validate(enrollment)
      return unless (member = enrollment.member)
      return true unless enrollment.new_record? || enrollment.changed?

      mission = enrollment.mission
      member_level = Member.cash_register_proficiencies[member.cash_register_proficiency]
      if member_level >= required_level(mission) ||
         mission.available_slots_count_for_a_time_slot(enrollment.start_time) > 1 ||
         mission.members.where(cash_register_proficiency: required_level(mission)..).any?
        return true
      end

      enrollment.errors.add :member, :insufficient_cash_register_proficiency
    end

    private

    def required_level(mission)
      level = mission.cash_register_close_out_required ? :close_out : :beginner
      Member.cash_register_proficiencies[level]
    end
  end
end
