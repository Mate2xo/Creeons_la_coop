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

    context 'when the one time slots are unavailable' do
      let(:slot_params) do
        { slot: { member_id: member.id,
                  start_times: [mission.start_date, mission.start_date + 90.minutes] } }
      end

      it "don't update any slots" do
        generate_enrollments_on_n_time_slots_of_a_mission(mission, 4)
        mission.slots.find_by(start_time: mission.start_date).update(member_id: nil)

        put mission_slot_path(mission.id, mission.slots.first.id), params: slot_params

        expect(Mission::Slot.where(mission_id: mission.id, member_id: member.id).count).to eq 0
      end

      it 'warns on time_slot unavailability' do
        generate_enrollments_on_n_time_slots_of_a_mission(mission, 4)

        put mission_slot_path(mission.id, mission.slots.first.id), params: slot_params

        expect(response.body).to include(I18n.t('activerecord.errors.models.slot.messages.unavailability',
                                                start_time: mission.start_date.strftime('%FT%T%:z')))
      end
    end

    def generate_enrollments_on_n_time_slots_of_a_mission(mission, members_count)
      members = create_list :member, members_count
      members.each do |member|
        enroll(mission, member)
      end
    end
  end
end
