# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/support/shared_examples')

RSpec.describe Enrollments::Mission90minTimeSlotsMatchValidator do
  context "when the datetimes do not match the mission's time_slots" do
    subject(:enrollment) do
      mission = create(:mission, :regulated)
      build(:enrollment, :one_hour, mission:)
    end

    it { is_expected.to be_invalid }

    it 'sets a :time_slot_mismatch error on the :mission' do
      enrollment.valid?
      expect(enrollment.errors).to be_of_kind :mission, :time_slot_mismatch
    end

    it_behaves_like 'a model without missing validation error translations' do
      let(:resource) { enrollment }
    end
  end

  context "when the datetimes match the mission's time_slots" do
    subject(:enrollment) { build(:enrollment, :on_first_time_slot) }

    it { is_expected.to be_valid }
  end

  context 'with a :standard mission' do
    subject(:enrollment) { build(:enrollment, :one_hour) }

    it 'is valid with any duration' do
      expect(enrollment).to be_valid
    end
  end
end
