# frozen_string_literal: true

# == Schema Information
#
# Table name: missions
#
#  id                       :bigint(8)        not null, primary key
#  name                     :string           not null
#  group_manager_mail       :string

# The members contribute to one or many groups. Each groups have a specific function in the association.
class Group < ApplicationRecord
  belongs_to :manager, class_name: :Member, inverse_of: 'managed_group', optional: true
  has_many :group_members, dependent: :destroy
  has_many :members, through: :group_members

  validates :name, presence: true, uniqueness: true
end
