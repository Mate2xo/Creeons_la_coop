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
require 'rails_helper'

RSpec.describe HistoryOfStaticSlotSelection, type: :model do
  it { is_expected.to belong_to(:static_slot) }
  it { is_expected.to belong_to(:member) }
end
