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
require 'rails_helper'

RSpec.describe MemberStaticSlot, type: :model do
  it { is_expected.to belong_to(:static_slot) }
  it { is_expected.to belong_to(:member) }
end
