# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticMembersRecruiter, type: :model do
  subject(:static_members_recruite) { StaticMembersRecruiter.new.call }

  let(:static_slot) { create :static_slot, week_day: 'Monday', week_type: 'A', start_time: DateTime.new(2021, 1, 4, 9) }
  let(:member) { create :member }

  before { allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10) }

  it 'enroll members with static slot to a corresponding mission' do
    mission = create :mission, start_date: DateTime.new(2021, 1, 4, 9), genre: 'regulated'
    member_static_slot = create :member_static_slot, member: member, static_slot: static_slot

    static_members_recruite

    expect(mission.members).to include(member_static_slot.member)
  end
end
