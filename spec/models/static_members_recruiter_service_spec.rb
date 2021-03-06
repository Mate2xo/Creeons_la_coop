# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticMembersRecruiter, type: :model do
  subject(:recruit_static_members) { StaticMembersRecruiter.new.call }

  let(:member) { create :member }

  before { allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10) }

  context 'when the member has one static_slot corresponding to a mission' do
    let(:create_static_slot_and_enroll_a_member_on_it) do
      static_slot = create :static_slot, week_day: 'Monday', week_type: 'A', start_time: DateTime.new(2021, 1, 4, 9)
      create :member_static_slot, member: member, static_slot: static_slot
    end

    it 'enrolls members having this static_slot to this mission' do
      create_static_slot_and_enroll_a_member_on_it
      mission = create :mission, start_date: DateTime.new(2021, 1, 4, 9), genre: 'regulated'

      recruit_static_members

      expect(mission.members).to include(member)
    end
  end

  context 'when the member has two static_slots corresponding to a mission' do
    let(:create_two_static_slots_and_enroll_a_member_on_those) do
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

    it 'enrolls members having this static_slot to this mission' do
      mission = create :mission, start_date: DateTime.new(2021, 1, 4, 9), genre: 'regulated'
      create_two_static_slots_and_enroll_a_member_on_those

      recruit_static_members

      expect(mission.members).to include(member)
    end
  end

  context 'when all static slots of all members have been assigned
  to a corresponding time slot in the upcoming missions' do
    subject(:recruit_static_members) do
      recruiter = StaticMembersRecruiter.new
      recruiter.call
      recruiter
    end

    let(:create_members_with_static_slot) do
      static_slot = create :static_slot, week_day: 'Monday', week_type: 'A', start_time: DateTime.new(2021, 1, 4, 9)
      create :member_static_slot, member: member, static_slot: static_slot
      static_slot2 = create :static_slot, week_day: 'Tuesday', week_type: 'A', start_time: DateTime.new(2021, 1, 5, 9)
      create :member_static_slot, member: member, static_slot: static_slot2
    end

    let(:create_missions) do
      create :mission, start_date: DateTime.new(2021, 1, 4, 9), genre: 'regulated'
      create :mission, start_date: DateTime.new(2021, 1, 5, 9), genre: 'regulated'
    end

    it 'The recruiter has no report' do
      create_members_with_static_slot
      create_missions

      recruiter = recruit_static_members

      expect(recruiter.reports.size).to eq 0
    end
  end

  context 'when a static slot of a given member has no available time slot in upcoming missions' do
    subject(:recruit_static_members) do
      recruiter = StaticMembersRecruiter.new
      recruiter.call
      recruiter
    end

    let(:create_members_with_static_slot) do
      static_slot = create :static_slot, week_day: 'Monday', week_type: 'A', start_time: DateTime.new(2021, 1, 4, 9)
      create :member_static_slot, member: member, static_slot: static_slot
      static_slot2 = create :static_slot, week_day: 'Tuesday', week_type: 'A', start_time: DateTime.new(2021, 1, 5, 9)
      create :member_static_slot, member: member, static_slot: static_slot2
    end

    it 'The recruiter has one report' do
      create_members_with_static_slot

      recruiter = recruit_static_members

      expect(recruiter.reports.size).to eq 2
    end
  end
end
