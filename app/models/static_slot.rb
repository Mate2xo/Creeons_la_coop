# frozen_string_literal: true

# == Schema Information
#
# Table name: calendar_locations
#
#  id                        :bigint(8)        not null, primary key
#  week_day                  :integer          not null
#  hour                      :integer          not null
#  minute                    :integer          not null
#  week_type                 :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null

# A StaticSlot refers to a place in calendar. It is combination of location in the week and a week_type.
class StaticSlot < ApplicationRecord
  has_many :static_slot_members, dependent: :destroy
  has_many :members, through: :static_slot_members

  enum week_day: { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }
  enum week_type: { A: 0, B: 1, C: 2, D: 3 }

  validates :week_day, presence: true
  validates :hour, presence: true, inclusion: 0..23
  validates :minute, presence: true, inclusion: 0..59
  validates :week_type, presence: true

  accepts_nested_attributes_for :members
end
