# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  id             :bigint           not null, primary key
#  member_id      :bigint           not null
#  mission_id     :bigint           not null
#  old_start_time :time
#  old_end_time   :time
#  start_time     :datetime
#  end_time       :datetime
#

require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe '.has_worked_this_month' do
    subject(:has_worked_this_month) { described_class.has_worked_this_month Date.current }

    context 'with enrollments on :standard Missions' do
      let!(:setup) { create(:mission, genre: :standard) { |mission| create(:enrollment, mission:) } }

      it 'returns them' do
        expect(has_worked_this_month.count).to eq 1
      end
    end

    context 'with enrollments on :regulated Missions' do
      let!(:setup) { create(:mission, genre: :regulated) { |mission| create(:enrollment, mission:) } }

      it 'returns them' do
        expect(has_worked_this_month.count).to eq 1
      end
    end

    context 'with enrollments on :shipping Missions' do
      let!(:setup) { create(:mission, genre: :shipping) { |mission| create(:enrollment, mission:) } }

      it 'returns them' do
        expect(has_worked_this_month.count).to eq 1
      end
    end

    context 'with enrollments on :event Missions' do
      let!(:setup) { create(:mission, genre: :event) { |mission| create(:enrollment, mission:) } }

      it 'does not return them' do
        expect(has_worked_this_month.count).to eq 0
      end
    end

    it 'returns' do
    end
  end

  describe 'instanciation' do
    let(:enrollment) { create(:enrollment) }

    it 'set :start_time default value to the associated mission start' do
      expect(enrollment.start_time.strftime('%T')).to eq enrollment.mission.start_date.strftime('%T')
    end

    it 'set :end_time default value to the associated mission end' do
      expect(enrollment.end_time.strftime('%T')).to eq enrollment.mission.due_date.strftime('%T')
    end
  end

  describe '#duration' do
    subject(:create_enrollment) do
      create(:enrollment, start_time: mission.start_date, end_time: mission.start_date + 2.hours, mission: mission)
    end

    let(:mission) { create(:mission) }

    it 'gives the duration of an enrollment in hours' do
      enrollment = create_enrollment

      expect(enrollment.duration).to eq 2
    end

    it 'returns 0 if any start_time attribute is undefined' do
      expect(Enrollment.new(end_time: Time.current).duration).to eq 0
    end

    it 'returns 0 if any end_time attribute is undefined' do
      expect(Enrollment.new(start_time: Time.current).duration).to eq 0
    end

    context 'when the duration is not equal to a natural number' do
      subject(:create_enrollment) do
        create(:enrollment, start_time: mission.start_date, end_time: mission.start_date + 1.5.hours, mission: mission)
      end

      it 'rounds off the duration to one decimal' do
        enrollment = create_enrollment

        expect(enrollment.duration).to eq 1.5
      end
    end
  end
end
