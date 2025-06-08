# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  roles      :string
#

# The members contribute to one or many groups. Each groups have a specific function in the association.
class Group < ApplicationRecord
  extend Enumerize

  has_many :group_managers, dependent: :destroy, foreign_key: :managed_group, inverse_of: :managed_group
  has_many :managers, class_name: :Member, inverse_of: 'managed_groups', through: :group_managers
  has_many :group_members, dependent: :destroy
  has_many :members, through: :group_members

  serialize :roles, type: Array, coder: YAML
  enumerize :roles, in: %i[redactor], multiple: true

  validates :name, presence: true, uniqueness: {case_sensitive: false}

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
      %i[managers members]
    else
      []
    end
  end
end
