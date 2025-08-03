# frozen_string_literal: true

module Enrollments
  # Checks if the given 'standard' mission has a place for a new enrollment
  class PlaceAvailabilityValidator < ActiveModel::Validator
    def validate(enrollment)
      mission = enrollment.mission
      return unless mission.standard? && mission.max_member_count && mission.persisted?
      return unless mission.max_member_count == mission.members.count

      enrollment.errors.add :mission, :full
    end
  end
end
