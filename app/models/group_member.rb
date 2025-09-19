# frozen_string_literal: true

# == Schema Information
#
# Table name: group_members
#
#  id         :bigint           not null, primary key
#  assignment :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint
#  member_id  :bigint
#
# Indexes
#
#  index_group_members_on_group_id   (group_id)
#  index_group_members_on_member_id  (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (member_id => members.id)
#
# Join model between a Group and a regular Member
class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :member
end
