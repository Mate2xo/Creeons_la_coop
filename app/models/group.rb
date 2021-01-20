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
  has_many :group_managers, dependent: :destroy, foreign_key: :managed_group, inverse_of: :managed_group
  has_many :managers, class_name: :Member, inverse_of: 'managed_groups', through: :group_managers
  has_many :group_members, dependent: :destroy
  has_many :members, through: :group_members

  validates :name, presence: true, uniqueness: true

  def self.localized_name_of_group_which_grant_right_to_members(name_to_localize)
    list_of_groups_with_rights = ['redactor']
    return nil unless list_of_groups_with_rights.include?(name_to_localize)

    I18n.t("activerecord.attributes.group.localized_names.#{name_to_localize}")
  end
end
