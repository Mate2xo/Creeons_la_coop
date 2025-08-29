# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/support/shared_examples')

RSpec.describe Enrollments::PlaceAvailabilityValidator do
  context 'with a mission having 1 enrollment slot left' do
    subject(:enrollment) do
      mission = create(:mission, max_member_count: 4, with_enrollments: 3)
      build(:enrollment, mission:)
    end

    it { is_expected.to be_valid }
  end

  context 'when filling all available enrollment slots of a mission at once' do
    subject(:enrollment) do
      mission = create(:mission, max_member_count: 4, with_enrollments: 4)
      mission.enrollments.last
    end

    it { is_expected.to be_valid }
  end

  context 'when removing an enrollment on a full mission' do
    subject(:mission) do
      create(:mission, max_member_count: 4, with_enrollments: 4)
    end

    it 'removes that enrollment' do
      expect { mission.enrollments.last.destroy }.to change { mission.enrollments.reload.count }.from(4).to(3)
    end
  end

  context 'when adding an enrollment on a full mission' do
    subject(:enrollment) do
      mission = create(:mission, max_member_count: 4, with_enrollments: 4)
      build(:enrollment, mission:)
    end

    it { is_expected.not_to be_valid }

    it 'sets a :full error on the :mission attribute' do
      enrollment.valid?
      expect(enrollment.errors).to be_of_kind :mission, :full
    end

    it_behaves_like 'a model without missing validation error translations' do
      let(:resource) { enrollment }
    end
  end
end
