# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/support/shared_examples')

RSpec.describe Enrollments::DurationValidator do
  context 'with a :standard mission' do
    context 'with a negative duration' do
      subject(:enrollment) do
        mission = create(:mission)
        build(:enrollment,
              start_time: mission.start_date,
              end_time: mission.start_date - 3.minutes)
      end

      it { is_expected.to be_invalid }

      it 'sets a :negative_duration error' do
        enrollment.valid?
        expect(enrollment.errors).to be_of_kind :base, :negative_duration
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { enrollment }
      end
    end

    context 'with a positive duration' do
      subject(:enrollment) { build(:enrollment) }

      it { is_expected.to be_valid }
    end
  end

  context 'with a :regulated mission' do
    context 'with a negative duration' do
      subject(:enrollment) do
        mission = create(:mission, :regulated)
        build(:enrollment,
              mission:,
              start_time: mission.start_date,
              end_time: mission.start_date - 3.minutes)
      end

      it { is_expected.to be_invalid }

      it 'sets a :negative_duration error' do
        enrollment.valid?
        expect(enrollment.errors).to be_of_kind :base, :negative_duration
      end
    end

    context 'with a positive duration' do
      subject(:enrollment) { build(:enrollment, mission: create(:mission, :regulated)) }

      it { is_expected.to be_valid }
    end

    context 'with a duration of 90 minutes' do
      subject(:enrollment) do
        mission = create(:mission, :regulated)
        build(:enrollment,
              mission:,
              start_time: mission.start_date,
              end_time: mission.start_date + Enrollment::TIME_SLOT_DURATION)
      end

      it { is_expected.to be_valid }
    end

    context 'with a duration not being a multiple of 90 minutes' do
      subject(:enrollment) do
        mission = create(:mission, :regulated)
        build(:enrollment,
              mission:,
              start_time: mission.start_date,
              end_time: mission.start_date + 10.minutes)
      end

      it { is_expected.to be_invalid }

      it 'sets a :duration_is_not_a_multiple_of_90_minutes error' do
        enrollment.valid?
        expect(enrollment.errors).to be_of_kind :base, :duration_is_not_a_multiple_of_90_minutes
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { enrollment }
      end
    end
  end
end
