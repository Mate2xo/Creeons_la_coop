# frozen_string_literal: true

# == Schema Information
#
# Table name: history_of_static_slot_selections
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  member_id      :bigint
#  static_slot_id :bigint
#
# Indexes
#
#  index_history_of_static_slot_selections_on_member_id       (member_id)
#  index_history_of_static_slot_selections_on_static_slot_id  (static_slot_id)
#
FactoryBot.define do
  factory :history_of_static_slot_selection do
    member
    static_slot
  end
end
