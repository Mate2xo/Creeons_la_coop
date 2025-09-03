# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  id             :bigint           not null, primary key
#  member_id      :bigint           not null
#  mission_id     :bigint           not null
#  old_start_time :time
#  old_end_time   :time
#  start_time     :datetime
#  end_time       :datetime
#

# Represents a member enrolling to a given Mission
class Enrollment < ApplicationRecord
  TIME_SLOT_DURATION = 90.minutes

  belongs_to :member
  belongs_to :mission

  before_validation :set_defaults
  before_validation :synchronise_date_info_with_parent_mission

  validates_with Enrollments::CashRegisterProficiencyValidator,
                 if: proc { mission.standard? || mission.regulated? }
  validates_with Enrollments::DurationValidator
  validates_with Enrollments::MemberUniquenessValidator, on: :create
  validates_with Enrollments::Mission90minTimeSlotsMatchValidator # regulated missions
  validates_with Enrollments::MissionDatesInclusionValidator
  validates_with Enrollments::PlaceAvailabilityValidator
  validates_with Enrollments::TimeSlotAvailabilityValidator # regulated missions

  scope :has_worked_this_month, lambda { |date|
    joins(:mission)
      .where(missions: {
               start_date: (date.beginning_of_month)..(date.end_of_month)
             })
      .where.not(missions: {genre: :event})
  }

  def self.ransackable_attributes(auth_object = nil)
    return [] unless auth_object

    case auth_object.user.role.to_sym
    when :super_admin, :admin
      column_names + _ransackers.keys
    else
      []
    end
  end

  def self.ransackable_associations(_auth_object = nil) = []

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

  def synchronise_date_info_with_parent_mission
    enrollment_and_mission_are_on_the_same_date = start_time.to_date == mission.start_date.to_date &&
                                                  end_time.to_date == mission.due_date.to_date
    return if enrollment_and_mission_are_on_the_same_date

    year, month, day = extract_date_info_from(mission.start_date)
    self.start_time = self.start_time.change(year: year, month: month, day: day)
    self.end_time = self.end_time.change(year: year, month: month, day: day)
  end

  def extract_date_info_from(date)
    [date.year, date.month, date.day]
  end
end
