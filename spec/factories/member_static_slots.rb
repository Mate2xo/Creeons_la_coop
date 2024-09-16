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
FactoryBot.define do
  factory :member_static_slot do
    member
    static_slot
  end
end
