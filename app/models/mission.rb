# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                                    :bigint           not null, primary key
#  name                                  :string           not null
#  description                           :text             not null
#  due_date                              :datetime
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  author_id                             :bigint
#  start_date                            :datetime
#  recurrent                             :boolean
#  max_member_count                      :integer
#  min_member_count                      :integer
#  delivery_expected                     :boolean          default(FALSE)
#  genre                                 :integer          default("standard")
#  cash_register_proficiency_requirement :integer          default("untrained")
#

# A Mission is an activity that has to be done for the Supermaket Team to function properly.
# Every member can create a mission
# Available methods: #addresses, #author, #due_date, #name, #description
# A regulated mission have several time_slots
# A time slot is a subdivision of mission duration
# A time slot last 90 minutes
# A time slot have several slots
# Slots count for a time slot is equal to :max_member_count
class Mission < ApplicationRecord
  belongs_to :author, class_name: 'Member', inverse_of: 'created_missions', optional: true
  has_many :enrollments, dependent: :destroy
  has_many :members, through: :enrollments
  has_and_belongs_to_many :productors
  has_and_belongs_to_many :addresses

  validates :name, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :due_date, presence: true
  validates :min_member_count, numericality: {only_integer: true, greater_than_or_equal_to: 0}, presence: true
  validates :max_member_count, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validates :genre, presence: true
  validates_with MissionValidators::DurationValidator
  validates_associated :enrollments

  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :enrollments, reject_if: :all_blank, allow_destroy: true

  enum :genre, {standard: 0, regulated: 1, event: 2}

  enum :cash_register_proficiency_requirement, {untrained: 0, beginner: 1, proficient: 2}

  attr_accessor :recurrence_rule, :recurrence_end_date, :recurrent_change

  def self.ransackable_attributes(auth_object = nil)
    return [] unless auth_object

    case auth_object.user.role.to_sym
    when :super_admin, :admin
      column_names + _ransackers.keys
    else
      []
    end
  end

  def self.ransackable_associations(auth_object = nil)
    return [] unless auth_object

    case auth_object.user.role.to_sym
    when :super_admin, :admin
      %i[enrollments members productors addresses]
    else
      []
    end
  end

  ##
  # Returns the duration of the mission in seconds, rounded to the nearest integer.
  # @return [Integer] The duration between due_date and start_date in seconds.
  def duration
    (due_date - start_date).round
  end

  ##
  # Returns an array of selectable 90-minute time slots for a regulated mission, filtered for the given member.
  # @param [Member, nil] member The member for whom to determine selectable time slots. If nil, returns all available slots.
  # @return [Array<DateTime>, nil] An array of selectable time slot start times, or nil if the mission is not regulated.
  def selectable_time_slots(member = nil)
    return nil unless genre == 'regulated'

    time_slots = []
    current_time_slot = start_date
    while current_time_slot < due_date
      time_slots << current_time_slot if time_slot_selectable?(current_time_slot, member)
      current_time_slot += 90.minutes
    end
    time_slots
  end

  # @param current_time_slot [DateTime]
  # @param member [Member]
  # @return [Boolean]
  def time_slot_already_taken_by_member?(current_time_slot, member)
    member_enrollment = enrollments.find_by(mission: self, member: member)
    return false if member_enrollment.nil?

    member_enrollment.contain_this_time_slot?(current_time_slot)
  end

  ##
  # Returns the number of available enrollment slots for a given time slot, ensuring the result is not negative.
  # @param [Time] time_slot - The time slot to check for availability.
  # @return [Integer] The number of available slots for the specified time slot.
  def available_slots_count_for_a_time_slot(time_slot)
    occupied_slots_count = enrollments.where('start_time <= :time_slot AND :time_slot < end_time',
                                             time_slot: time_slot).count
    (max_member_count.to_i - occupied_slots_count).clamp(0, nil)
  end

  private

  def time_slot_selectable?(current_time_slot, member)
    return true if member.present? && time_slot_already_taken_by_member?(current_time_slot, member)

    time_slot_available?(current_time_slot)
  end

  def time_slot_available?(current_time_slot)
    enrollments.where('start_time <= :current_time_slot AND :current_time_slot < end_time',
                      current_time_slot: current_time_slot)
               .count < max_member_count
  end
end
