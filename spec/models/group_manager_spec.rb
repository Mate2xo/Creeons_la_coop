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
require 'rails_helper'

RSpec.describe GroupManager, type: :model do
  it { is_expected.to belong_to(:manager).class_name('Member') }
  it { is_expected.to belong_to(:managed_group).class_name('Group') }
end
