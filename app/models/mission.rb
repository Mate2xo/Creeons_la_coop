# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                :bigint(8)        not null, primary key
#  name              :string           not null
#  description       :text             not null
#  due_date          :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  author_id         :bigint(8)
#  start_date        :datetime
#  recurrent         :boolean
#  max_member_count  :integer
#  min_member_count  :integer
#  delivery_expected :boolean          default(FALSE)
#  event             :boolean          default(FALSE)
#

# A Mission is an activity that has to be done for the Supermaket Team to function properly.
# Every member can create a mission
# Available methods: #addresses, #author, #due_date, #name, #description
#
class Mission < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :author, class_name: 'Member', inverse_of: 'created_missions'

  has_many :participations, dependent: :destroy, foreign_key: :event, inverse_of: :event
  has_many :participants, class_name: 'Member', through: :participations

  has_many :enrollments, dependent: :destroy
  has_many :members, through: :enrollments

  has_many :slots, dependent: :destroy, class_name: 'Mission::Slot'
  has_many :members, through: :slots

  has_and_belongs_to_many :productors
  has_and_belongs_to_many :addresses

  validates :name, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :due_date, presence: true
  validates :min_member_count, numericality: { only_integer: true }, presence: true
  validates :max_member_count, numericality: { only_integer: true }, presence: true
  validates_with DurationValidator

  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :participations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :slots, reject_if: :all_blank, allow_destroy: true

  enum cash_register_proficiency_requirement: { untrained: 0, beginner: 1, proficient: 2 }

  # Virtual attributes
  attr_accessor :recurrence_rule
  attr_accessor :recurrence_end_date

  def time_slots_count
    (due_date - start_date) / 60 / 90
  end

  def duration
    due_date - start_date
  end
end
