# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Missions::RecurrentUpdateTransaction do
  subject(:transaction) { described_class.new.call(params:, old_mission: mission) }

  context 'with a truthy :recurrent_change param' do
    let(:params) do
      attributes_for(:mission,
                     name: 'updated_mission',
                     recurrent_change: true,
                     start_date: mission.start_date + 3.hours,
                     due_date: mission.due_date + 3.hours)
    end

    let(:mission) { create(:mission) }

    it 'updates futures missions that match the same week day, hour, and genre' do
      other_missions = create_future_missions_with_matching_time_and_weekday(mission)

      transaction

      other_missions.each do |mission|
        expect(mission.reload.name).to eq 'updated_mission'
      end
    end

    it "doesn't update pasts missions that match the same week day, hour, and genre" do
      other_mission = create(:mission, start_date: mission.start_date - 2.days)

      transaction

      expect(other_mission.reload.name).not_to eq 'updated_mission'
    end

    it "doesn't update any :start_date attribute" do
      other_missions = create_future_missions_with_matching_time_and_weekday(mission)
      original_start_dates = other_missions.map(&:start_date)

      transaction

      other_missions.each &:reload
      expect(other_missions.pluck(:start_date)).to eq original_start_dates
    end

    it "doesn't update any :due_date attribute" do
      other_missions = create_future_missions_with_matching_time_and_weekday(mission)
      original_due_dates = other_missions.map(&:due_date)

      transaction

      other_missions.each &:reload
      expect(other_missions.pluck(:due_date)).to eq original_due_dates
    end
  end
end

def create_future_missions_with_matching_time_and_weekday(mission)
  occurrence_date = mission.start_date + 7.days
  other_missions = []
  4.times do
    other_missions << create(:mission, start_date: occurrence_date, genre: mission.genre)
    occurrence_date += 7.days
  end
  other_missions
end
