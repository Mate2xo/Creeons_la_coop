# frozen_string_literal: true

module Enrollments
  # If there is only one slot left on a regulated time slot,
  # checks that there is at least one Member trained on the cash register.
  class CashRegisterProficiencyValidator < ActiveModel::Validator
    ##
    # Validates that a time slot will have at least one member with the required cash-register proficiency.
    #
    # Runs only for enrollments that have a member and are either new or changed. If the enrolling member
    # already meets the mission's required proficiency, if the mission has more than one available slot for
    # the enrollment's start time, or if any existing mission member meets the required proficiency, the
    # validator succeeds. Otherwise it adds :insufficient_cash_register_proficiency to enrollment.errors[:member].
    # @param [Enrollment] enrollment - The enrollment being validated.
    # @return [true, nil] Returns true when validation passes; returns nil after adding an error when it fails.
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

    ##
    # Determine the numeric cash register proficiency level required for a mission.
    # Chooses :close_out if `mission.cash_register_close_out_required` is true, otherwise :beginner,
    # and returns the corresponding numeric value from `Member.cash_register_proficiencies`.
    # @param [Object] mission - an object that responds to `cash_register_close_out_required`.
    # @return [Integer] the numeric proficiency level used for validation.
    def required_level(mission)
      level = mission.cash_register_close_out_required ? :close_out : :beginner
      Member.cash_register_proficiencies[level]
    end
  end
end
