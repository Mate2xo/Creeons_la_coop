require 'rails_helper'

RSpec.describe ScheduleGenerator, type: :model do
  describe '#generate_schedule' do
    subject(:generate_schedule) { ScheduleGenerator.new(current_member).generate_schedule }

    let(:current_member) { create :member }

    before { allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10) }

    it 'generates missions for the next month' do
      expect { generate_schedule }.to change(Mission, :count).by(78)
    end

    it 'enrolls members with static slot' do
      static_slot_member = create :static_slot_member

      generate_schedule

      expect(Mission::Slot.find_by(start_time: DateTime.new(2021, 1, 4, 9),
                                   member_id: static_slot_member.member.id)).to be_present
    end

    describe '#enroll_members_with_static_slot' do
      subject(:enroll_members_with_static_slot) do
        ScheduleGenerator.new(current_member).enroll_members_with_static_slot(mission, current_hour)
      end

      let(:mission) { create :mission, start_date: DateTime.new(2021, 1, 4, 9) }
      let(:current_hour) { mission.start_date }

      it 'enroll_members_with_static_slot_to_a_mission' do
        static_slot_member = create :static_slot_member

        enroll_members_with_static_slot

        expect(Mission::Slot.find_by(mission_id: mission.id, member_id: static_slot_member.member.id)).to be_present
      end
    end
  end
end
