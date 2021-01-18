# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticMembersRecruiter, type: :model do
  subject(:static_members_recruite) { StaticMembersRecruiter.new.call }

  let(:member) { create :member }

  before { allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10) }

  context 'when the member has one :static_slot corresponding to the mission' do
    let(:create_static_slot_and_enroll_member_that_one) do
      static_slot = create :static_slot, week_day: 'Monday', week_type: 'A', start_time: DateTime.new(2021, 1, 4, 9)
      create :member_static_slot, member: member, static_slot: static_slot
    end

    it 'enroll members with :static_slot to this mission' do
      create_static_slot_and_enroll_member_that_one
      mission = create :mission, start_date: DateTime.new(2021, 1, 4, 9), genre: 'regulated'

      static_members_recruite

      expect(mission.members).to include(member)
    end
  end

  context 'when the member has two :static_slots corresponding to the mission' do
    let(:create_static_slots_and_enroll_member_those_there) do
      static_slots = []
      static_slots << (create :static_slot, week_day: 'Monday', week_type: 'A', start_time: DateTime.new(2021, 1, 4, 9))
      static_slots << (create :static_slot,
                              week_day: 'Monday',
                              week_type: 'A',
                              start_time: DateTime.new(2021, 1, 4, 10, 30))

      static_slots.each do |static_slot|
        create :member_static_slot, member: member, static_slot: static_slot
      end
    end

    it 'enroll members with :static_slots to this mission' do
      mission = create :mission, start_date: DateTime.new(2021, 1, 4, 9), genre: 'regulated'
      create_static_slots_and_enroll_member_those_there

      static_members_recruite

      expect(mission.members).to include(member)
    end
  end
end
