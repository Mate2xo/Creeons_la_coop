# frozen_string_literal: true

# == Schema Information
#
# Table name: group_managers
#
#  id               :bigint           not null, primary key
#  managed_group_id :bigint
#  manager_id       :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Join model between a Group and its managing Member
class GroupManager < ApplicationRecord
  belongs_to :managed_group, class_name: :Group
  belongs_to :manager, class_name: :Member
end
