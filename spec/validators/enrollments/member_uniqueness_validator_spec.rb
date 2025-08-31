# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/support/shared_examples')

RSpec.describe Enrollments::MemberUniquenessValidator do
  context 'when the member is not enrolled yet' do
    subject(:enrollment) do
      build(:enrollment)
    end

    it { is_expected.to be_valid }
  end

  context 'when the member is already enrolled' do
    subject(:enrollment) do
      existing_enrollment = create(:enrollment)
      build(:enrollment,
            mission: existing_enrollment.mission,
            member: existing_enrollment.member,
            start_time: existing_enrollment.mission.start_date,
            end_time: existing_enrollment.mission.due_date)
    end

    it { is_expected.not_to be_valid }

    it 'sets an :already_enrolled on the :member attribute' do
      enrollment.valid?
      expect(enrollment.errors).to be_of_kind :member, :already_enrolled
    end

    it_behaves_like 'a model without missing validation error translations' do
      let(:resource) { enrollment }
    end
  end
end
