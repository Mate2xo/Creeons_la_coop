# frozen_string_literal: true

# This validator check if the mission have a place for the new enrollment
class AvailabilityPlaceValidator < ActiveModel::Validator
  def validate(enrollment)
    return unless enrollment.mission.genre == 'standard'
    return if enrollment.mission.max_member_count.nil?
    return unless mission_full?(enrollment.mission)

    failure_message = I18n.t('activerecord.errors.models.enrollment.full_mission')
    enrollment.errors.add :base, failure_message
  end

  def mission_full?(mission)
    mission.max_member_count == mission.members.count
  end
end
