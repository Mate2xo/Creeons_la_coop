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

  describe 'validations' do
    context 'when a new enrollment is created where mission is full' do
      it 'raises an error' do
        mission =  create :mission, max_member_count: 4 
        enroll_n_members_on_mission(mission, 4)
        extra_enrollment = Enrollment.new(mission: mission)

        expect(extra_enrollment).to_not be_valid
      end
    end
  end

  describe '#duration' do
    subject(:create_enrollment) do
      create :enrollment, start_time: mission.start_date, end_time: mission.start_date + 2.hours, mission: mission
    end

    let(:mission) { create :mission }

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
        create :enrollment, start_time: mission.start_date, end_time: mission.start_date + 1.5.hours, mission: mission
      end

      it 'rounds off the dureation to one decimal' do
        enrollment = create_enrollment

        expect(enrollment.duration).to eq 1.5
      end
    end
  end

  def enroll_n_members_on_mission(mission, members_count)
    members = create_list :member, members_count
    members.each do |member|
      create :enrollment,
             member: member,
             mission: mission,
             start_time: mission.start_date,
             end_time: mission.start_date + 3.hours
    end
  end
end
