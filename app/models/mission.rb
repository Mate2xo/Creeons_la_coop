# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id          :bigint(8)        not null, primary key
#  name        :string           not null
#  description :text             not null
#  due_date    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :bigint(8)
#

# A Mission is an activity that has to be done for the Supermaket Team to function properly.
# Every member can create a mission
# Available methods: #addresses, #author, #due_date, #name, #description
class Mission < ApplicationRecord
  belongs_to :author, class_name: "Member", inverse_of: 'created_missions'
  has_and_belongs_to_many :members
  has_and_belongs_to_many :productors
  has_and_belongs_to_many :addresses
  validates :name, presence: true
  validates :description, presence: true
  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true
end
