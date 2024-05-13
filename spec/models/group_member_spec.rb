# == Schema Information
#
# Table name: group_members
#
#  id         :bigint           not null, primary key
#  group_id   :bigint
#  member_id  :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  assignment :text
#
require 'rails_helper'

RSpec.describe GroupMember, type: :model do
  it { is_expected.to belong_to(:member) }
  it { is_expected.to belong_to(:group) }
end
