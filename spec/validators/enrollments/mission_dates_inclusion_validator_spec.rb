# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require Rails.root.join('spec/support/shared_examples')

RSpec.describe Enrollments::MissionDatesInclusionValidator do
  context "when the datetimes of the enrollment aren't inside the mission's period" do
    subject(:enrollment) do
      mission = create(:mission)
      build(:enrollment,
            start_time: mission.start_date,
            end_time: (mission.due_date + 3.minutes))
    end

    it { is_expected.to be_invalid }

    it 'sets an :inconsistent_datetimes error on the record' do
      enrollment.valid?
      expect(enrollment.errors).to be_of_kind :base, :inconsistent_datetimes
    end

    it_behaves_like 'a model without missing validation error translations' do
      let(:resource) { enrollment }
    end
  end

  context "when the datetimes of the enrollment are within the mission's period" do
    subject(:enrollment) { build :enrollment }

    it { is_expected.to be_valid }
  end
end
