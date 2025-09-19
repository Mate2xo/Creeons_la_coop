# frozen_string_literal: true

# == Schema Information
#
# Table name: member_static_slots
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  member_id      :bigint
#  static_slot_id :bigint
#
# Indexes
#
#  index_member_static_slots_on_member_id       (member_id)
#  index_member_static_slots_on_static_slot_id  (static_slot_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (static_slot_id => static_slots.id)
#
FactoryBot.define do
  factory :member_static_slot do
    member
    static_slot
  end
end
