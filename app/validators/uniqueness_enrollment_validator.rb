# frozen_string_literal: true

# This validator check if the member is already enrolled on this mission
class UniquenessEnrollmentValidator < ActiveModel::Validator
  def validate(enrollment)
    return unless enrollment.mission.members.include?(enrollment.member)

    failure_message = I18n.t('activerecord.errors.models.enrollment.member_already_enrolled')
    enrollment.errors.add :base, failure_message
  end
end
