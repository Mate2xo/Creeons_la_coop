# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Enrollments::TimeSlotAvailabilityValidator do
  context 'with a mission having 1 enrollment slot left' do
    subject(:enrollment) do
      mission = create(:mission, :regulated, max_member_count: 4, with_enrollments: 3)
      build(:enrollment, mission:)
    end

    it { is_expected.to be_valid }
  end

  context 'with a mission having only one time slot left' do
    subject(:mission) do
      create(:mission, :regulated, max_member_count: 1) do |mission|
        create(:enrollment, :on_first_time_slot, mission:) and mission.reload
      end
    end

    it 'is valid when taking the last time slot available' do
      enrollment = build(:enrollment, :on_last_time_slot, mission:)
      expect(enrollment).to be_valid
    end

    it 'is invalid when taking an occupied time slot' do
      enrollment = build(:enrollment, :on_first_time_slot, mission:)
      expect(enrollment).not_to be_valid
    end

    it 'is invalid when taking both occupied and available time slots' do
      enrollment = build(:enrollment, mission:, start_time: mission.start_date, end_time: mission.due_date)
      expect(enrollment).not_to be_valid
    end
  end

  context 'with an enrollment that already exists on a full mission' do
    subject(:enrollment) do
      mission = create(:mission, :regulated, max_member_count: 4, with_enrollments: 4)
      mission.enrollments.last
    end

    it { is_expected.to be_valid }
  end

  context 'when removing an enrollment on a full mission' do
    subject(:mission) do
      create(:mission, :regulated, max_member_count: 4, with_enrollments: 4)
    end

    it 'removes that enrollment' do
      expect { mission.enrollments.last.destroy }.to change { mission.enrollments.reload.count }.from(4).to(3)
    end
  end

  context 'when adding an enrollment on a full mission' do
    subject(:enrollment) do
      mission = create(:mission, max_member_count: 4, with_enrollments: 4, genre: :regulated)
      build(:enrollment, mission:)
    end

    it { is_expected.not_to be_valid }

    it 'sets a :no_slots_available error on the :mission attribute' do
      enrollment.valid?
      expect(enrollment.errors).to be_of_kind :mission, :no_slots_available
    end
  end
end
