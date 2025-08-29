# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/support/shared_examples')

RSpec.describe Enrollments::TimeSlotAvailabilityValidator do
  context 'with a mission having 1 enrollment slot left' do
    subject(:enrollment) do
      mission = create(:mission, :regulated, max_member_count: 4, with_enrollments: 3)
      build(:enrollment, mission:)
    end

    it { is_expected.to be_valid }
  end

  context 'with a mission having only one time slot left' do
    let(:mission) do
      create(:mission, :regulated, max_member_count: 1) do |mission|
        member = create(:member, :trained)
        create(:enrollment, :on_first_time_slot, mission:, member:)
      end
    end

    context 'when taking the last time slot available' do
      subject(:enrollment) { build(:enrollment, :on_last_time_slot, mission:) }

      it { is_expected.to be_valid }
    end

    context 'when taking an occupied time slot' do
      subject(:enrollment) { build(:enrollment, :on_first_time_slot, mission:) }

      it { is_expected.to be_invalid }

      it 'sets a :no_slots_available error on the :mission' do
        enrollment.valid?
        expect(enrollment.errors).to be_of_kind :mission, :no_slots_available
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { enrollment }
      end
    end

    context 'when taking both occupied and available time slots' do
      subject(:enrollment) do
        build(:enrollment, mission:, start_time: mission.start_date, end_time: mission.due_date)
      end

      it { is_expected.to be_invalid }

      it 'sets a :no_slots_available error on the :mission' do
        enrollment.valid?
        expect(enrollment.errors).to be_of_kind :mission, :no_slots_available
      end
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

    it_behaves_like 'a model without missing validation error translations' do
      let(:resource) { enrollment }
    end
  end
end
