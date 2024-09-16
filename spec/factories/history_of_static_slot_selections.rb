# frozen_string_literal: true

# == Schema Information
#
# Table name: history_of_static_slot_selections
#
#  id             :bigint           not null, primary key
#  member_id      :bigint
#  static_slot_id :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :history_of_static_slot_selection do
    member
    static_slot
  end
end
