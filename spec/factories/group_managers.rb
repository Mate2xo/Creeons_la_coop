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
FactoryBot.define do
  factory :group_manager do
    managed_group factory: :group
    manager factory: :member
  end
end
