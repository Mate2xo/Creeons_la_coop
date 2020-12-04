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

  describe 'update' do
    subject(:put_slot) { put mission_slot_path(mission.id, mission.slots.first.id), params: slot_params }

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

    context 'when one of the time slots is unavailable' do
      let(:slot_params) do
        { slot: { member_id: member.id,
                  start_times: [mission.start_date, mission.start_date + 90.minutes] } }
      end

      it 'does not update any slot' do
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

    context 'when the mission have a cash_register_proficiency_requirement higher than cash_register_proficiency of the
    member and only one place is still' do
      let(:mission) { create :mission, cash_register_proficiency_requirement: 1 }
      let(:slot_params) do
        { slot: { member_id: member.id,
                  start_times: [mission.start_date, mission.start_date + 90.minutes] } }
      end
      let(:i18n_call) do
        I18n.t('activerecord.errors.models.mission.messages.insufficient_proficiency',
               start_time: mission.start_date.strftime('%Hh%M'),
               end_time: (mission.start_date + 90.minutes).strftime('%Hh%M'))
      end
      let(:i18n_call2) do
        I18n.t('activerecord.errors.models.mission.messages.insufficient_proficiency',
               start_time: (mission.start_date + 90.minutes).strftime('%Hh%M'),
               end_time: (mission.start_date + 180.minutes).strftime('%Hh%M'))
      end

      it "don't update the slots" do
        generate_enrollments_on_n_time_slots_of_a_mission(mission, 3)
        free_slots = mission.slots.select { |slot| slot.member_id.nil? }

        put_slot

        expect(free_slots.map { |slot| slot.reload.member_id }).to all(be_nil)
      end

      it 'displays an alert' do
        generate_enrollments_on_n_time_slots_of_a_mission(mission, 3)

        put_slot

        expect(response.body).to include(i18n_call).and include(i18n_call2)
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
