# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  member_id  :bigint(8)        not null
#  mission_id :bigint(8)        not null
#  id         :bigint(8)        not null, primary key
#  start_time :time
#  end_time   :time
#

# Represents a member enrolling to a given Mission
class Enrollment < ApplicationRecord
  belongs_to :member
  belongs_to :mission

  before_validation :set_defaults

  validates_with EnrollmentValidators::CashRegisterProficiencyValidator
  validates_with EnrollmentValidators::DatetimesInclusionValidator
  validates_with EnrollmentValidators::UniquenessEnrollmentValidator, on: :create
  validates_with EnrollmentValidators::AvailabilityPlaceValidator
  validates_with EnrollmentValidators::AvailabilitySlotValidator
  validates_with EnrollmentValidators::DurationValidator
  validates_with EnrollmentValidators::MatchingMissionTimeSlotsValidator

  scope :has_worked_this_month, lambda { |date|
    joins(:mission)
      .where(missions: {
               start_date: (date.beginning_of_month)..(date.end_of_month)
             })
      .where.not(missions: { genre: 'event' })
  }

  def duration
    return 0 if start_time.nil? || end_time.nil?

    ((end_time - start_time) / 60 / 60).round 1
  end

  def contain_this_time_slot?(time_slot)
    start_time <= time_slot && time_slot < end_time
  end

  private

  def set_defaults
    self.start_time ||= mission.start_date
    self.end_time ||= mission.due_date
  end
end
