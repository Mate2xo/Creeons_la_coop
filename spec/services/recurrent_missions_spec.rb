# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecurrentMissions do
  describe '#generate' do
    subject(:generate) { described_class.new.generate mission }

    let(:mission) do
      build(:mission,
            :recurrent,
            start_date: DateTime.current.beginning_of_week,
            due_date: DateTime.current.beginning_of_week + 3.hours)
    end

    it 'creates a mission instance for each required occurence' do
      generate
      expect(Mission.count).to eq(4) # Tue, Wed, Fri, Sat
    end

    context 'with a recurrent_end_date being more than 12 months later' do
      let(:mission) do
        build(:mission, :recurrent, recurrence_end_date: 14.months.from_now)
      end

      it 'sets the maximum recurrence_end_date to the end of next month' do
        generate
        expect(Mission.last.due_date).to be < 13.months.from_now.beginning_of_month
      end
    end
  end

  describe '#validate' do
    subject(:validate) { described_class.validate mission }

    context 'when no recurrence_rule are given' do
      let(:mission) { build(:mission, :recurrent, recurrence_rule: '') }

      it 'returns a :select_recurrence_type_and_end feedback message' do
        expect(validate).to eq I18n.t('services.recurrent_missions.select_recurrence_type_and_end')
      end
    end

    context 'when no recurrence_end_date are given' do
      let(:mission) { build(:mission, :recurrent, recurrence_end_date: '') }

      it 'returns a :select_recurrence_type_and_end feedback message' do
        expect(validate).to eq I18n.t('services.recurrent_missions.select_recurrence_type_and_end')
      end
    end

    context 'when recurrence_end_date is prior to present day' do
      let(:mission) { build(:mission, :recurrent, recurrence_end_date: 1.month.ago) }

      it 'returns a :recurrence_end_must_not_be_past feedback message' do
        expect(validate).to eq I18n.t('services.recurrent_missions.recurrence_end_must_not_be_past')
      end
    end

    context 'with all recurrence attributes present' do
      let(:mission) { build(:mission, :recurrent) }

      it { is_expected.to be true }
    end
  end
end
