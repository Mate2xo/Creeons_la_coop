# frozen_string_literal: true

# == Schema Information
#
# Table name: enrollments
#
#  member_id  :bigint(8)        not null
#  mission_id :bigint(8)        not null
#  id         :bigint(8)        not null, primary key
#  start_time :time
#  end_time   :time
#

require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe 'instanciation' do
    let(:enrollment) { create :enrollment }

    it 'set :start_time default value to the associated mission start' do
      expect(enrollment.start_time.strftime('%T')).to eq enrollment.mission.start_date.strftime('%T')
    end
    it 'set :end_time default value to the associated mission end' do
      expect(enrollment.end_time.strftime('%T')).to eq enrollment.mission.due_date.strftime('%T')
    end
  end

  describe '#duration' do
    let(:current_time) { DateTime.current }

    it 'gives the duration of an enrollment in hours' do
      enrollment = create :enrollment, start_time: current_time, end_time: current_time + 2.hours

      expect(enrollment.duration).to eq 2
    end

    it 'gives a rounded duration in hours' do
      enrollment = build :enrollment, start_time: current_time, end_time: current_time + 1.5.hours

      expect(enrollment.duration).to eq 1.5
    end

    it 'returns 0 if any start_time attribute is undefined' do
      expect(Enrollment.new(end_time: Time.current).duration).to eq 0
    end

    it 'returns 0 if any end_time attribute is undefined' do
      expect(Enrollment.new(start_time: Time.current).duration).to eq 0
    end
  end
end
