# frozen_string_literal: true

module Enrollments
  # Checks if the member is already enrolled on this mission
  class MemberUniquenessValidator < ActiveModel::Validator
    ##
    # Validates that the enrollment's member is not already enrolled in the mission.
    # Adds an error to the enrollment if the member is already included in the mission's members.
    def validate(enrollment)
      return unless enrollment.mission.members.include?(enrollment.member)

      enrollment.errors.add :member, :already_enrolled, name: enrollment.member.full_name
    end
  end
end
