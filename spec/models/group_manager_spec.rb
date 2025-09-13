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
require 'rails_helper'

RSpec.describe GroupManager, type: :model do
  it { is_expected.to belong_to(:manager).class_name('Member') }
  it { is_expected.to belong_to(:managed_group).class_name('Group') }
end
