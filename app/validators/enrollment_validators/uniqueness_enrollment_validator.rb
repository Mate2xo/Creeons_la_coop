# frozen_string_literal: true

module EnrollmentValidators
  # This validator check if the member is already enrolled on this mission
  class UniquenessEnrollmentValidator < ActiveModel::Validator
    def validate(enrollment)
      return unless enrollment.mission.members.include?(enrollment.member)

      enrollment.errors.add :member, :already_enrolled, name: enrollment.member.full_name
    end
  end
end
