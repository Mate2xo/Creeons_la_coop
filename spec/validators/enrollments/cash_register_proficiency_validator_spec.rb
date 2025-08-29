# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/support/shared_examples')

RSpec.describe Enrollments::CashRegisterProficiencyValidator do
  context 'when enrolling an untrained member on an empty mission' do
    subject(:enrollment) do
      mission = create(:mission, :regulated)
      build(:enrollment, mission:)
    end

    it { is_expected.to be_valid }
  end

  context 'with a mission having untrained members, and only 1 enrollment slot left' do
    let(:mission) do
      create(:mission, max_member_count: 4) do |mission|
        mission.enrollments = create_list(:enrollment, 3, mission:)
      end
    end

    context 'with a new enrollment of another untrained member' do
      subject(:enrollment) do
        member = create(:member, cash_register_proficiency: :untrained)
        build(:enrollment, mission:, member:)
      end

      it { is_expected.not_to be_valid }

      it 'sets an :insufficient_cash_register_proficiency error' do
        enrollment.valid?
        expect(enrollment.errors).to be_of_kind :member, :insufficient_cash_register_proficiency
      end

      it_behaves_like 'a model without missing validation error translations' do
        let(:resource) { enrollment }
      end
    end

    context 'with a new enrollment of a trained member' do
      subject(:enroll) do
        member = create(:member, cash_register_proficiency: :beginner)
        build(:enrollment, mission:, member:)
      end

      it { is_expected.to be_valid }
    end
  end

  context 'when filling all available enrollment slots of a mission at once' do
    subject(:enrollment) do
      mission = create(:mission, max_member_count: 4, with_enrollments: 4)
      mission.enrollments.last
    end

    it { is_expected.to be_valid }
  end
end
