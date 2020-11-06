# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/slot_enrollment.rb'

RSpec.configure do |c|
  c.include Helpers::SlotEnrollment
end

RSpec.describe 'Slots request', type: :request do
  let(:member) { create :member }
  let(:mission) { create :mission }

  before { sign_in member }

  describe 'to take a time slot' do
    let(:create_other_member) { create :member }

    it "update a slot with the member's id" do
      put mission_slot_path(mission.id, mission.slots.first.id),
        params: { slot: { member_id: member.id, start_times: [mission.start_date] } }

      expect(mission.slots.where(member_id: member.id, start_time: mission.start_date).count).to eq 1
    end

    context 'when a member deselect a slot time' do
      it 'nullifies the member_id field of the related slot' do
        slot = mission.slots.find_by(start_time: mission.start_date)
        slot.update(member_id: member.id)

        put mission_slot_path(mission.id, mission.slots.first.id),
          params: { slot: { member_id: member.id } }

        expect(slot.reload.member_id).to be_nil
      end
    end

    context 'when the time slots are unavailable' do
      it "doesn't update" do
        generate_enrollments_on_n_time_slots_of_a_mission(4)

        put mission_slot_path(mission.id, mission.slots.first.id),
          params: { slot: { member_id: member.id,
                            start_times: [mission.start_date] } }
        expect(Mission::Slot.where(mission_id: mission.id, member_id: member.id).count).to eq 0
      end
    end


    def generate_enrollments_on_n_time_slots_of_a_mission(members_count)
      members = create_list :member, members_count
      members.each do |member|
        enroll(mission, member)
      end
    end
  end
end

