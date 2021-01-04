# frozen_string_literal: true

# == Schema Information
#
# Table name: calendar_locations
#
#  id                        :bigint(8)        not null, primary key
#  week_day                  :integer          not null
#  start_time                :datetime         not null
#  week_type                 :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null

# A StaticSlot refers to a place in calendar. It is combination of location in the week and a week_type.
# A StaticSlot are coordinates in a 4 weeks cycle.
class StaticSlot < ApplicationRecord
  has_many :member_static_slots, dependent: :destroy
  has_many :members, through: :member_static_slots

  enum week_day: { Monday: 0, Tuesday: 1, Wednesday: 2, Thursday: 3, Friday: 4, Saturday: 5, Sunday: 6 }
  enum week_type: { A: 0, B: 1, C: 2, D: 3 }

  validates :start_time, presence: true
  validates :week_day, presence: true
  validates :week_type, presence: true

  # Virtual attributes
  attr_accessor :hour
  attr_accessor :minute
end
