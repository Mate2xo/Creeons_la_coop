# frozen_string_literal: true

# == Schema Information
#
# Table name: member_static_slots
#
#  id             :bigint           not null, primary key
#  static_slot_id :bigint
#  member_id      :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# join model
class MemberStaticSlot < ApplicationRecord
  belongs_to :member
  belongs_to :static_slot
end
