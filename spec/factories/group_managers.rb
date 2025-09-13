# frozen_string_literal: true

# == Schema Information
#
# Table name: group_managers
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  managed_group_id :bigint
#  manager_id       :bigint
#
# Indexes
#
#  index_group_managers_on_managed_group_id  (managed_group_id)
#  index_group_managers_on_manager_id        (manager_id)
#
# Foreign Keys
#
#  fk_rails_...  (managed_group_id => groups.id)
#  fk_rails_...  (manager_id => members.id)
#
FactoryBot.define do
  factory :group_manager do
    managed_group factory: :group
    manager factory: :member
  end
end
