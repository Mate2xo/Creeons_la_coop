# frozen_string_literal: true

module Enrollments
  # Checks if the given 'standard' mission has a place for a new enrollment
  class PlaceAvailabilityValidator < ActiveModel::Validator
    ##
    # Validates that a mission has available places before allowing a new enrollment.
    # Adds an error to the enrollment if the mission is at full capacity and the member is not already enrolled.
    # @param enrollment The enrollment object to validate.
    def validate(enrollment)
      mission = enrollment.mission
      return unless mission.standard? && mission.max_member_count && mission.persisted?
      return if mission.members.include?(enrollment.member)
      return unless mission.max_member_count == mission.members.count

      enrollment.errors.add :mission, :full
    end
  end
end
