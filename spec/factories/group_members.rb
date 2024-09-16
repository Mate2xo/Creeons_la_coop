# frozen_string_literal: true

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
FactoryBot.define do
  factory :group_member do
    group
    member
  end
end
