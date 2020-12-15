# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticMembersRecruiter, type: :model do
  subject(:static_members_recruite) { StaticMembersRecruiter.call }

  before { allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10) }

  it 'enroll members with static slot to a corresponding mission' do
    mission = create :mission, start_date: DateTime.new(2021, 1, 4, 9)
    static_slot_member = create :static_slot_member

    static_members_recruite

    expect(Mission::Slot.find_by(mission_id: mission.id, member_id: static_slot_member.member.id)).to be_present
  end
end
